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
    
    var parentViewmodel: ParentViewModel!
    
    var saveBtn: UIButton!
    
    private var bag = DisposeBag()
    
    override func viewDidLoad() { super.viewDidLoad()
        
        loadParentViewModel(questions: questions) // hard-coded campaignId...
        
        loadComponentSizes()
        
        loadSaveBtn()
        
        //renderOnScreen(questions: questions)
        
        //self.view.insertSubview(scrollView, at: 0)
        
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
    
    //private func renderOnScreen(questions: [SingleQuestion]) {
        //_ = questions.map(drawStackView)
    
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
            let res = getRadioBtnsView(question: singleQuestion.question,
                                       answer: singleQuestion.answer,
                                       frame: fr)
            stackerView = res.0; btnViews = res.1
            
            radioBtnsViewModelBinder.hookUp(view: stackerView,
                                            btnViews: btnViews as! [RadioBtnView],
                                            viewmodel: viewmodel as! RadioViewModel,
                                            bag: bag)
        case .checkbox:
            let res = getCheckboxBtnsView(question: singleQuestion.question,
                                          answer: singleQuestion.answer,
                                          frame: fr)
            stackerView = res.0; btnViews = res.1
            
            checkboxBtnsViewModelBinder.hookUp(view: stackerView,
                                               btnViews: btnViews as! [CheckboxView],
                                               viewmodel: viewmodel as! CheckboxViewModel,
                                               bag: bag)

        case .radioBtnWithInput:
            let res = getRadioBtnsWithInputView(question: singleQuestion.question,
                                                answer: singleQuestion.answer,
                                                frame: fr)
            stackerView = res.0; btnViews = res.1
            
            radioBtnsWithInputViewModelBinder.hookUp(view: stackerView,
                                                     btnViews: btnViews as! [RadioBtnView],
                                                     viewmodel: viewmodel as! RadioWithInputViewModel,
                                                     bag: bag)

        case .checkboxWithInput:
            let res = getCheckboxBtnsWithInputView(question: singleQuestion.question,
                                                   answer: singleQuestion.answer,
                                                   frame: fr)
            stackerView = res.0; btnViews = res.1
            
            checkboxBtnsWithInputViewModelBinder.hookUp(view: stackerView,
                                                        btnViews: btnViews as! [CheckboxView],
                                                        viewmodel: viewmodel as! CheckboxWithInputViewModel,
                                                        bag: bag)
            
        case .switchBtn:
            let res = getSwitchBtns(question: singleQuestion.question,
                                    answer: singleQuestion.answer,
                                    frame: fr)
            stackerView = res.0; btnViews = res.1

            switchBtnsViewModelBinder.hookUp(view: stackerView,
                                             btnViews: btnViews as! [LabelBtnSwitchView],
                                             viewmodel: viewmodel as! SwitchBtnsViewModel,
                                             bag: bag)
        case .textField:
            let res = getLabelAndTextField(question: singleQuestion.question,
                                          answer: singleQuestion.answer,
                                          frame: fr)
            stackerView = res.0; btnViews = res.1
            
            txtFieldViewModelBinder.hookUp(view: stackerView,
                                           labelAndTextView: btnViews.first as! LabelAndTextField,
                                           viewmodel: viewmodel as! LabelWithTextFieldViewModel,
                                           bag: bag)
        case .textWithOptions:
            let res = getLabelAndTextView(question: singleQuestion.question,
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
    
    // hocu da Tap na embeded radio btn (nalazi se digged in u ViewStacker-u) pogoni ostale btn-e da menjaju sliku + da save actual za MODEL
    // s druge strane, ANSWER bi trebalo da pogoni sve btns, jer moze da se upari i preko "id" i preko "value"
    
    private func getRadioBtnsView(question: Question, answer: Answer?, frame: CGRect) -> (ViewStacker, [RadioBtnView]) {
        
        let stackerView = viewFactory.getStackedRadioBtns(question: question, answer: answer, frame: frame)
        
        let btnViews = stackerView.components.flatMap { view -> [RadioBtnView] in
            return (view as? OneRowStacker)?.components as? [RadioBtnView] ?? [ ]
        }
        
        _ = btnViews.enumerated().map { $0.element.radioBtn.tag = $0.offset } // dodeli svakome unique TAG
        
        return (stackerView, btnViews)
        
    }
    
    private func getCheckboxBtnsView(question: Question, answer: Answer?, frame: CGRect) -> (ViewStacker, [CheckboxView]) {
        
        let stackerView = viewFactory.getStackedCheckboxBtns(question: question, answer: answer, frame: frame)
        
        let btnViews = stackerView.components.flatMap { view -> [CheckboxView] in
            return (view as? OneRowStacker)?.components as? [CheckboxView] ?? [ ]
        }
        
        _ = btnViews.enumerated().map { $0.element.radioBtn.tag = $0.offset } // dodeli svakome unique TAG
        
        return (stackerView, btnViews)
        
    }
    
    private func getRadioBtnsWithInputView(question: Question, answer: Answer?, frame: CGRect) -> (ViewStacker, [UIView]) {
        
        let stackerView = viewFactory.getStackedRadioBtnsWithInput(question: question, answer: answer, frame: frame)
        
        let elements = stackerView.components.flatMap { view -> [UIView] in
            return (view as? OneRowStacker)?.components ?? [ ]
        }
        
        _ = elements.enumerated().map {
            if $0.offset == elements.count - 1 {
                $0.element.tag = $0.offset
            } else if let btnView = $0.element as? RadioBtnView  {
                btnView.radioBtn.tag = $0.offset
            }
        } // dodeli svakome unique TAG
        
        return (stackerView, elements)
        
    }
   
    private func getCheckboxBtnsWithInputView(question: Question, answer: Answer?, frame: CGRect) -> (ViewStacker, [UIView]) {
        
        let stackerView = viewFactory.getStackedCheckboxBtnsWithInput(question: question, answer: answer, frame: frame)
        
        let elements = stackerView.components.flatMap { view -> [UIView] in
            return (view as? OneRowStacker)?.components ?? [ ]
        }
        
        _ = elements.enumerated().map {
            if $0.offset == elements.count - 1 {
                $0.element.tag = $0.offset
            } else if let btnView = $0.element as? CheckboxView  {
                btnView.radioBtn.tag = $0.offset
            }
        } // dodeli svakome unique TAG
        return (stackerView, elements)
    }
    
    private func getSwitchBtns(question: Question, answer: Answer?, frame: CGRect) -> (ViewStacker, [UIView]) {
        
        let stackerView = viewFactory.getStackedSwitchBtns(question: question, answer: answer, frame: frame)
        
        let btnViews = stackerView.components.flatMap { view -> [LabelBtnSwitchView] in
            return (view as? OneRowStacker)?.components as? [LabelBtnSwitchView] ?? [ ]
        }
        
        _ = btnViews.enumerated().map { $0.element.switcher.tag = $0.offset } // dodeli svakome unique TAG
        
        return (stackerView, btnViews)
    }
    
    private func getLabelAndTextField(question: Question, answer: Answer?, frame: CGRect) -> (ViewStacker, [LabelAndTextField]) {
        
        //let stackerView = viewFactory.getStackedLblAndTextView(question: question, answer: answer, frame: frame)
        let stackerView = viewFactory.getStackedLblAndTextFieldView(questionWithAnswers: [(question, answer)], frame: frame)
        
        let views = stackerView.components.flatMap { view -> [LabelAndTextField] in
            return (view as? OneRowStacker)?.components as? [LabelAndTextField] ?? [ ]
        }
        
        _ = views.enumerated().map { $0.element.textField.tag = $0.offset } // dodeli svakome unique TAG
        
        return (stackerView, views)
        
    }
    
    // refactor ovo, mora biti samo 1 !!!
    private func getLabelAndTextView(question: Question, answer: Answer?, frame: CGRect) -> (ViewStacker, [LabelAndTextView]) {
        
        //let stackerView = viewFactory.getStackedLblAndTextView(question: question, answer: answer, frame: frame)
        let stackerView = viewFactory.getStackedLblAndTextView(questionWithAnswers: [(question, answer)], frame: frame)
        
        let views = stackerView.components.flatMap { view -> [LabelAndTextView] in
            return (view as? OneRowStacker)?.components as? [LabelAndTextView] ?? [ ]
        }
        
        //_ = views.enumerated().map { $0.element.textView.tag = $0.offset } // dodeli svakome unique TAG
        _ = views.enumerated().map { $0.element.textView.tag = question.id } // dodeli mu unique TAG kakav je questionId !!
        
        return (stackerView, views)
        
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



func getOneRowHeightFor(componentType type: QuestionType) -> CGFloat {
    switch type {
        // sta sa textArea ?
    case .textField:
        return CGFloat.init(80)
    case .radioBtn:
        return CGFloat.init(50)
    case .checkbox:
        return CGFloat.init(50)
    case .radioBtnWithInput:
        return CGFloat.init(50)
    case .checkboxWithInput:
        return CGFloat.init(50)
    case .switchBtn:
        return CGFloat.init(50)
    default:
        return 0.0
    }
}

// QuestionType

struct Question {
    var id: Int
    var type: QuestionType
    var headlineText = ""
    var inputTxt = ""
    var options = [String]()
    var multipleSelection = false
}

protocol StackViewToViewModelBinder {
    associatedtype ViewModel: ViewModelType
    associatedtype View: UIView
    func hookUp(view: ViewStacker, btnViews: [View], viewmodel: ViewModel, bag: DisposeBag)
}

enum InternalError: Error {
    case viewmodelConversion
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
