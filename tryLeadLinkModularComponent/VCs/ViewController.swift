//
//  ViewController.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 17/12/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {//}, RadioBtnListener {
    
    lazy var viewFactory = ViewFactory.init(bounds: self.view.bounds)
    let viewmodelFactory = ViewmodelFactory.init()
    lazy var viewStackerFactory = ViewStackerFactory.init(viewFactory: viewFactory,
                                                          bag: bag,
                                                          delegate: self)

    @IBOutlet weak var tableView: UITableView!
    
    let questions: [SingleQuestion] = {
        return QuestionsDataProvider.init(campaignId: 1).questions // hard-coded campaignId...
    }()
    
    private var parentViewmodel: ParentViewModel!
    private var questionIdsViewSizes = [Int: CGSize]()
    private var saveBtn: UIButton!
    private var bag = DisposeBag()
    
    override func viewDidLoad() { super.viewDidLoad()
        
        loadParentViewModel(questions: questions)
        
        loadComponentSizes()
        
        self.saveBtn = SaveButton()
        
        listenToSaveEvent()
        
    }
    
    private func loadParentViewModel(questions: [SingleQuestion]) {
        
        let childViewmodels = questions.compactMap { singleQuestion -> Questanable? in
            return viewmodelFactory.makeViewmodel(singleQuestion: singleQuestion) as? Questanable
        }
        parentViewmodel = ParentViewModel.init(viewmodels: childViewmodels)
    }

    private func loadComponentSizes() {
        
        _ = questions.enumerated().map({ (arg) -> Void in
            let (offset, singleQuestion) = arg
            guard let viewmodel = parentViewmodel.childViewmodels[singleQuestion.question.id] else {return}
            questionIdsViewSizes[offset] = viewStackerFactory.drawStackView(singleQuestion: singleQuestion,
                                                                                   viewmodel: viewmodel).bounds.size
        })
    }
    
    private func listenToSaveEvent() {
        saveBtn.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { [weak self] (_) in

                _ = self?.parentViewmodel.childViewmodels.compactMap({ viewmodelDict in
                    print("imam viewmodel = \(viewmodelDict.value)")
                    let viewmodel = viewmodelDict.value
                    if let viewmodel = viewmodel as? RadioViewModel {
                        print("RadioViewModel.answer = \(String(describing: viewmodel.answer))")
                    } else if let viewmodel = viewmodel as? CheckboxViewModel {
                        print("CheckboxViewModel.answer = \(String(describing: viewmodel.answer))")
                    } else if let viewmodel = viewmodel as? RadioWithInputViewModel {
                        print("RadioWithInputViewModel.answer = \(String(describing: viewmodel.answer))")
                    } else if let viewmodel = viewmodel as? CheckboxWithInputViewModel {
                        print("CheckboxWithInputViewModel.answer = \(String(describing: viewmodel.answer))")
                    } else if let viewmodel = viewmodel as? SwitchBtnsViewModel {
                        print("SwitchBtnsViewModel.answer = \(String(describing: viewmodel.answer))")
                    } else if let viewmodel = viewmodel as? LabelWithTextFieldViewModel {
                        print("LabelWithTextFieldViewModel.answer = \(String(describing: viewmodel.answer))")
                    } else if let viewmodel = viewmodel as? SelectOptionTextFieldViewModel {
                        print("LabelWithTextFieldViewModel.answer = \(String(describing: viewmodel.answer))")
                    }
                })
            })
            .disposed(by: bag)
    }
    
}

extension ViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        textView.resignFirstResponder()
        
        guard
            let chooseOptionsVC = UIStoryboard.main.instantiateViewController(withIdentifier: "ChooseOptionsVC") as? ChooseOptionsVC,
            let childViewmodel = parentViewmodel.childViewmodels[textView.tag] as? SelectOptionTextFieldViewModel else {
                return
        }
        
        let dataSourceAndDelegate = QuestionOptionsTableViewDataSourceAndDelegate(selectOptionTextViewModel: childViewmodel)
        
        chooseOptionsVC.dataSourceAndDelegate = dataSourceAndDelegate
        
        chooseOptionsVC.doneWithOptions.subscribe(onNext: { [weak self] (dataSource) in
            if let dataSource = dataSource as? QuestionOptionsTableViewDataSourceAndDelegate {
                self?.navigationController?.popViewController(animated: true)
                guard let newContent = dataSource.observableAnswer.value?.content else {return}
                childViewmodel.answer?.content = newContent
                textView.text = newContent.reduce("", { ($0 + "\n" + $1) })
                textView.tintColor = UIColor.clear
                if newContent.count > 1 {
                    textView.sizeToFit()
                } else {
                    textView.frame = CGRect.init(origin: textView.frame.origin, size: CGSize.init(width: textView.bounds.width, height: 80))
                }
                
                guard let cell = UIView.closestParentObject(for: textView, ofType: UITableViewCell.self),
                    let index = self?.tableView.indexPath(for: cell)?.row else {
                    fatalError("error in view hierarchy or no index from tableView!!!")
                }
                
                (textView as? OptionsTextView)?.formatLayout()
                
                self?.questionIdsViewSizes[index] = textView.bounds.size
                self?.tableView.reloadData()
                
            }
        }).disposed(by: bag)
        
        self.navigationController?.pushViewController(chooseOptionsVC, animated: true)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parentViewmodel.childViewmodels.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.removeAllSubviews()
        
        if indexPath.row == parentViewmodel.childViewmodels.count { // save btn
            saveBtn.center = CGPoint.init(x: cell.bounds.midX, y: cell.bounds.midY)
            cell.addSubview(saveBtn)
        } else {
            let singleQuestion = questions[indexPath.row]
            if let viewmodel = parentViewmodel.childViewmodels[singleQuestion.question.id] {
                let stackerView = viewStackerFactory.drawStackView(singleQuestion: singleQuestion, viewmodel: viewmodel)
                stackerView.frame = cell.bounds
                cell.addSubview(stackerView)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return questionIdsViewSizes[indexPath.row]?.height ?? saveBtn.bounds.height
    }
    
}
