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

class ViewController: UIViewController, RadioBtnListener {
    
    lazy var viewFactory = ViewFactory.init(bounds: self.view.bounds)
    let viewmodelFactory = ViewmodelFactory.init()
    
    var scrollView: QuestionsScrollView!
    
    var radioBtnsViewModelBinder = StackViewToRadioBtnsViewModelBinder()
    var radioBtnsWithInputViewModelBinder = StackViewToRadioBtnsWithInputViewModelBinder()
    var checkboxBtnsViewModelBinder = StackViewToCheckboxBtnsViewModelBinder()
    var checkboxBtnsWithInputViewModelBinder = StackViewToCheckboxBtnsWithInputViewModelBinder()
    
    var parentViewmodel: ParentViewModel!
    
    private var bag = DisposeBag()
    
    @IBAction func leftBtnsTapped(_ sender: UIButton) {
        leftScenariosTapped(sender: sender)
    }
    
    @IBAction func scenarioTapped(_ sender: UIButton) {
        scenarioIsTapped(sender: sender)
    }
    
    @IBAction func radioScenarioTapped(_ sender: UIButton) {
        radioScenarioIsTapped(sender: sender)
    }
    
    override func viewDidLoad() { super.viewDidLoad()
        
        scrollView = QuestionsScrollView.init(frame: self.view.frame,
                                              confirmBtn: SaveButton.init(frame: CGRect.init(origin: CGPoint.init(x: 200, y: 1500), size: CGSize.init(width: 240, height: 44))))
        
        let questions = QuestionsDataProvider.init(campaignId: 1).questions
        
        loadParentViewModel(questions: questions) // hard-coded campaignId...
        
        renderOnScreen(questions: questions)
        
        self.view.insertSubview(scrollView, at: 0)
        scrollView.confirmBtn?.rx.controlEvent(.touchUpInside)
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
                    }
                })
            })
            .disposed(by: bag)
    }
    
    private func loadParentViewModel(questions: [SingleQuestion]) {
        
        let childViewmodels = questions.compactMap { singleQuestion -> Questanable? in
            return viewmodelFactory.makeViewmodel(singleQuestion: singleQuestion) as? Questanable
        }
        parentViewmodel = ParentViewModel.init(viewmodels: childViewmodels)
    }

    private func renderOnScreen(questions: [SingleQuestion]) {
        _ = questions.map(drawStackView)
    }
    
    private func drawStackView(singleQuestion: SingleQuestion) {
        
        let question = singleQuestion.question
        let viewmodel = parentViewmodel.childViewmodels[question.id]
        
        let lastVertPos = (scrollView.subviews.last?.frame)?.maxY ?? CGFloat(0)
        
        let height = getOneRowHeightFor(componentType: singleQuestion.question.type)
        let origin = CGPoint.init(x: 0, y: lastVertPos)
        let fr = CGRect.init(origin: origin, size: CGSize.init(width: viewFactory.bounds.width, height: height))
        
        var stackerView: ViewStacker!
        var btnViews: [UIView]
        switch question.type {
        case "radioBtn":
            print("nacrtaj radioBtn")
            let res = getRadioBtnsView(question: singleQuestion.question,
                                       answer: singleQuestion.answer,
                                       frame: fr)
            stackerView = res.0; btnViews = res.1
            stackerView.frame.origin.y = lastVertPos
            
            radioBtnsViewModelBinder.hookUp(view: stackerView,
                                            btnViews: btnViews as! [RadioBtnView],
                                            viewmodel: viewmodel as! RadioViewModel,
                                            bag: bag)
        case "checkbox":
            print("nacrtaj checkbox")
            let res = getCheckboxBtnsView(question: singleQuestion.question,
                                          answer: singleQuestion.answer,
                                          frame: fr)
            stackerView = res.0; btnViews = res.1
            stackerView.frame.origin.y = lastVertPos
            
            checkboxBtnsViewModelBinder.hookUp(view: stackerView,
                                               btnViews: btnViews as! [CheckboxView],
                                               viewmodel: viewmodel as! CheckboxViewModel,
                                               bag: bag)

        case "radioBtnWithInput":
            print("nacrtaj radioBtnWithInput")
            let res = getRadioBtnsWithInputView(question: singleQuestion.question,
                                                answer: singleQuestion.answer,
                                                frame: fr)
            stackerView = res.0; btnViews = res.1
            stackerView.frame.origin.y = lastVertPos
            
            radioBtnsWithInputViewModelBinder.hookUp(view: stackerView,
                                                     btnViews: btnViews as! [RadioBtnView],
                                                     viewmodel: viewmodel as! RadioWithInputViewModel,
                                                     bag: bag)

        case "checkboxWithInput":
            print("nacrtaj checkboxWithInput")
            let res = getCheckboxBtnsWithInputView(question: singleQuestion.question,
                                                   answer: singleQuestion.answer,
                                                   frame: fr)
            stackerView = res.0; btnViews = res.1
            stackerView.frame.origin.y = lastVertPos
            
            checkboxBtnsWithInputViewModelBinder.hookUp(view: stackerView,
                                                        btnViews: btnViews as! [CheckboxView],
                                                        viewmodel: viewmodel as! CheckboxWithInputViewModel,
                                                        bag: bag)
        default: break
        }
        if let stackerView = stackerView {
            print("stackerView.bounds.height = \(stackerView.bounds.height)")
            self.scrollView.addSubview(stackerView)
        }
    }
    
    private func leftScenariosTapped(sender: UIButton) {
        
        switch sender.tag {
            case 0: // radio
                
                let height = getOneRowHeightFor(componentType: "radioBtn")
                let fr = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: viewFactory.bounds.width, height: height))
                
                guard let data = SingleQuestion.init(forQuestion: 0) else {return}
            
                let (stackerView, btnViews) = getRadioBtnsView(question: data.question, answer: data.answer, frame: fr)
                
                guard let radioViewModel = parentViewmodel.childViewmodels.first as? RadioViewModel else {return}

                radioBtnsViewModelBinder.hookUp(view: stackerView, btnViews: btnViews, viewmodel: radioViewModel, bag: bag)
            
            self.scrollView.addSubview(stackerView)
            
        case 1: // checkbox
            
            let height = getOneRowHeightFor(componentType: "checkbox")
            let fr = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: viewFactory.bounds.width, height: height))
            
            guard let data = SingleQuestion.init(forQuestion: 1) else {return}
           
            let (stackerView, btnViews) = getCheckboxBtnsView(question: data.question, answer: data.answer, frame: fr)
            
            guard let checkboxViewModel = parentViewmodel.childViewmodels.filter({ viewmodel -> Bool in
                viewmodel is CheckboxViewModel
            }).first as? CheckboxViewModel else {return}
            
            checkboxBtnsViewModelBinder.hookUp(view: stackerView,
                                               btnViews: btnViews,
                                               viewmodel: checkboxViewModel,
                                               bag: bag)

            stackerView.frame.origin.y += 300

            self.scrollView.addSubview(stackerView)
            
        case 2: // radio with input
            
            let height = getOneRowHeightFor(componentType: "radioBtn")
            let fr = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: viewFactory.bounds.width, height: height))
            
            guard let data = SingleQuestion.init(forQuestion: 2) else {return}
            guard let radioWithInputViewModel = parentViewmodel.childViewmodels.filter({ viewmodel -> Bool in
                viewmodel is RadioWithInputViewModel
            }).first as? RadioWithInputViewModel else {return }
            
            let (stackerView, btnViews) = getRadioBtnsWithInputView(question: data.question, answer: data.answer, frame: fr)
            
            radioBtnsWithInputViewModelBinder.hookUp(view: stackerView,
                                                     btnViews: btnViews,
                                                     viewmodel: radioWithInputViewModel,
                                                     bag: bag)
            stackerView.frame.origin.y += 700
            
            self.scrollView.addSubview(stackerView)
            
        case 3: // checkbox with input
            
            let height = getOneRowHeightFor(componentType: "checkbox")
            let fr = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: viewFactory.bounds.width, height: height))
            
            guard let data = SingleQuestion.init(forQuestion: 3) else {
                return
            }
            
            let (stackerView, btnViews) = getCheckboxBtnsWithInputView(question: data.question, answer: data.answer, frame: fr)
            
            guard let checkboxWithInputViewModel = parentViewmodel.childViewmodels.filter({ viewmodel -> Bool in
                viewmodel is CheckboxWithInputViewModel
            }).last as? CheckboxWithInputViewModel else {
                return
            }
            
            checkboxBtnsWithInputViewModelBinder.hookUp(view: stackerView,
                                                       btnViews: btnViews,
                                                       viewmodel: checkboxWithInputViewModel,
                                                       bag: bag)
            
            stackerView.frame.origin.y += 1000
            
            self.scrollView.addSubview(stackerView)
            
        default: break
        }
        
    }
    
    private func scenarioIsTapped(sender: UIButton) {
        
    }
    
    private func radioScenarioIsTapped(sender: UIButton) {
        
    }
    
    // hocu da Tap na embeded radio btn (nalazi se digged in u ViewStacker-u) pogoni ostale btn-e da menjaju sliku + da save actual za MODEL
    // s druge strane, ANSWER bi trebalo da pogoni sve btns, jer moze da se upari i preko "id" i preko "value"
    
    // implement me !!!
    
    private func hookUp(view: ViewStacker, btnViews: [UIView], checkboxWithInputViewModel viewmodel: CheckboxWithInputViewModel) { // osim Question viewmodel treba da ima i Answer !!!
        
//        let inputCreator = CheckboxWithInputViewmodelInputCreator.init(viewmodel: viewmodel)
//        let textDrivers = inputCreator.createTxtDrivers()
//
//        _ = textDrivers.enumerated().map { (offset, textDriver) in
//            print(offset)
//            guard let observer = (btnViews[offset] as? OptionTxtUpdatable)?.optionTxt else { return }
//
//            textDriver
//                .drive(observer)
//                .disposed(by: bag)
//
//            textDrivers.last?.asObservable()
//                .subscribe(onNext: { (val) in
//                    if val == "" {
//                        (btnViews.last as? UITextField)?.placeholder = "type city"
//                    }
//                })
//                .disposed(by: bag)
//        }
//
        
        
        
        //        let values = inputCreator.createRadioBtnsInput(btnViews: btnViews)
        //
        //        let input = RadioViewModel.Input.init(ids: values, answer: viewmodel.answer)
        //
        //        let output = viewmodel.transform(input: input) // vratio sam identican input na output
        //
        //        // ovo radi... ali nije PRAVI Reactive !
        //        output.ids.subscribe(onNext: { val in
        //            let active = buttons.first(where: { $0.tag == val })
        //            var inactive = buttons
        //            inactive.remove(at: val) // jer znam da su indexed redom..
        //            _ = inactive.map({
        //                btnViews[$0.tag].isOn = false
        //            })
        //            _ = active.map({
        //                btnViews[$0.tag].isOn = true
        //            })
        //        }).disposed(by: bag)
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
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
    
    // saznao si da je user tap na radio btn sa tag == index
    func radioBtnTapped(index: Int) {
        print("radioBtnTapped za index = \(index)")
        // ako je radioBtn emitovao, pogasi sve preostale, sacuvaj na sebi vrednost itd...
        
    }
    
}

func getOneRowHeightFor(componentType type: String) -> CGFloat {
    switch type {
    case "textField":
        return CGFloat.init(80)
    case "radioBtn":
        return CGFloat.init(50)
    case "checkbox":
        return CGFloat.init(50)
    case "radioBtnWithInput":
        return CGFloat.init(50)
    case "checkboxWithInput":
        return CGFloat.init(50)
    case "switch":
        return CGFloat.init(60)
    default:
        return 0.0
    }
}


struct Question {
    var id: Int
    var type: String
    var headlineText = ""
    var inputTxt = ""
    var options = [String]()
}

protocol StackViewToViewModelBinder {
    associatedtype ViewModel: ViewModelType
    associatedtype View: UIView
    func hookUp(view: ViewStacker, btnViews: [View], viewmodel: ViewModel, bag: DisposeBag)
}

func getViewModelFrom<T: ViewModelType>(viewModel: Questanable) throws -> T {
    if let radioViewmodel = viewModel as? RadioViewModel {
        return radioViewmodel as! T
    } else if let checkboxViewModel = viewModel as? CheckboxViewModel {
        return checkboxViewModel as! T
    } else if let radioWithInputViewmodel = viewModel as? RadioWithInputViewModel {
        return radioWithInputViewmodel as! T
    } else if let checkboxWithInputViewModel = viewModel as? CheckboxWithInputViewModel {
        return checkboxWithInputViewModel as! T
    }
    
    throw InternalError.viewmodelConversion // fall back (better exception...)
}

enum InternalError: Error {
    case viewmodelConversion
}
