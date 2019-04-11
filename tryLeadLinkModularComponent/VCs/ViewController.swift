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
    lazy var viewStackerFactory = ViewStackerFactory.init(viewFactory: viewFactory, bag: bag)

    @IBOutlet weak var tableView: UITableView!
    
    var radioBtnsViewModelBinder = StackViewToRadioBtnsViewModelBinder()
    var radioBtnsWithInputViewModelBinder = StackViewToRadioBtnsWithInputViewModelBinder()
    var checkboxBtnsViewModelBinder = StackViewToCheckboxBtnsViewModelBinder()
    var checkboxBtnsWithInputViewModelBinder = StackViewToCheckboxBtnsWithInputViewModelBinder()
    var switchBtnsViewModelBinder = StackViewToSwitchBtnsViewModelBinder()
    var txtFieldViewModelBinder = TextFieldViewModelBinder()
    let txtViewModelBinder = TextFieldWithOptionsViewModelBinder()
    var questionIdsViewSizes = [Int: CGSize]()
    let questions: [SingleQuestion] = {
        return QuestionsDataProvider.init(campaignId: 1).questions
    }()
    
    private var parentViewmodel: ParentViewModel!
    
    var saveBtn: UIButton!
    
    private var bag = DisposeBag()
    
    override func viewDidLoad() { super.viewDidLoad()
        
        loadParentViewModel(questions: questions) // hard-coded campaignId...
        
        loadComponentSizes()
        
        loadSaveBtn()
        
    }
    
    private func loadParentViewModel(questions: [SingleQuestion]) {
        
        let childViewmodels = questions.compactMap { singleQuestion -> Questanable? in
            return viewmodelFactory.makeViewmodel(singleQuestion: singleQuestion) as? Questanable
        }
        parentViewmodel = ParentViewModel.init(viewmodels: childViewmodels)
    }

    private func loadComponentSizes() {
        
        _ = questions.enumerated().map({ (offset, singleQuestion) -> Void in
            questionIdsViewSizes[offset] = drawStackView(singleQuestion: singleQuestion).bounds.size
        })
    }
    
    private func loadSaveBtn() {
    
        self.saveBtn = SaveButton.init(frame: CGRect.init(origin: .zero, size: CGSize.init(width: 240, height: 44)))
        
        tableView.index
        
        listenToSaveEvent()

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
    
    
    private func drawStackView(singleQuestion: SingleQuestion) -> ViewStacker {
        
        let question = singleQuestion.question
        let viewmodel = parentViewmodel.childViewmodels[question.id]
        
        let height = getOneRowHeightFor(componentType: singleQuestion.question.type)
        let fr = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: viewFactory.bounds.width, height: height))
        
        var stackerView: ViewStacker!
        var btnViews: [UIView]
        switch question.type {
        case .radioBtn:
            
            let res = viewStackerFactory.getRadioBtnsView(question: singleQuestion.question,
                                                          answer: singleQuestion.answer,
                                                          frame: fr)
            stackerView = res.0; btnViews = res.1
            
            radioBtnsViewModelBinder.hookUp(view: stackerView,
                                            btnViews: btnViews as! [RadioBtnView],
                                            viewmodel: viewmodel as! RadioViewModel,
                                            bag: bag)
        case .checkbox:
            let res = viewStackerFactory.getCheckboxBtnsView(question: singleQuestion.question,
                                                             answer: singleQuestion.answer,
                                                             frame: fr)
            stackerView = res.0; btnViews = res.1
            
            checkboxBtnsViewModelBinder.hookUp(view: stackerView,
                                               btnViews: btnViews as! [CheckboxView],
                                               viewmodel: viewmodel as! CheckboxViewModel,
                                               bag: bag)

        case .radioBtnWithInput:
            let res = viewStackerFactory.getRadioBtnsWithInputView(question: singleQuestion.question,
                                                                   answer: singleQuestion.answer,
                                                                   frame: fr)
            stackerView = res.0; btnViews = res.1
            
            radioBtnsWithInputViewModelBinder.hookUp(view: stackerView,
                                                     btnViews: btnViews as! [RadioBtnView],
                                                     viewmodel: viewmodel as! RadioWithInputViewModel,
                                                     bag: bag)

        case .checkboxWithInput:
            let res = viewStackerFactory.getCheckboxBtnsWithInputView(question: singleQuestion.question,
                                                                      answer: singleQuestion.answer,
                                                                      frame: fr)
            stackerView = res.0; btnViews = res.1
            
            checkboxBtnsWithInputViewModelBinder.hookUp(view: stackerView,
                                                        btnViews: btnViews as! [CheckboxView],
                                                        viewmodel: viewmodel as! CheckboxWithInputViewModel,
                                                        bag: bag)
            
        case .switchBtn:
            let res = viewStackerFactory.getSwitchBtns(question: singleQuestion.question,
                                                       answer: singleQuestion.answer,
                                                       frame: fr)
            stackerView = res.0; btnViews = res.1

            switchBtnsViewModelBinder.hookUp(view: stackerView,
                                             btnViews: btnViews as! [LabelBtnSwitchView],
                                             viewmodel: viewmodel as! SwitchBtnsViewModel,
                                             bag: bag)
        case .textField:
            let res = viewStackerFactory.getLabelAndTextField(question: singleQuestion.question,
                                                              answer: singleQuestion.answer,
                                                              frame: fr)
            stackerView = res.0; btnViews = res.1
            
            txtFieldViewModelBinder.hookUp(view: stackerView,
                                           labelAndTextView: btnViews.first as! LabelAndTextField,
                                           viewmodel: viewmodel as! LabelWithTextFieldViewModel,
                                           bag: bag)
        case .textWithOptions:
            let res = viewStackerFactory.getLabelAndTextView(question: singleQuestion.question,
                                                             answer: singleQuestion.answer,
                                                             frame: fr)
            stackerView = res.0; btnViews = res.1
            
            txtViewModelBinder.hookUp(view: stackerView,
                                      labelAndTextView: btnViews.first as! LabelAndTextView,
                                      viewmodel: viewmodel as! SelectOptionTextFieldViewModel,
                                      bag: bag)
            (btnViews.first as! LabelAndTextView).textView.sizeToFit()
            
            stackerView.resizeHeight(by: 20)
            
            (btnViews.first as! LabelAndTextView).textView.delegate = self
            
        default: break
        }
        
        return stackerView
        
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
            let question = questions[indexPath.row]
            let stackerView = drawStackView(singleQuestion: question)
            stackerView.frame = cell.bounds
            cell.addSubview(stackerView)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return questionIdsViewSizes[indexPath.row]?.height ?? saveBtn.bounds.height
    }
    
}
