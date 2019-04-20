//
//  ViewStackerFactory.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 11/04/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewStackerFactory {
    
    private var viewFactory: ViewFactory
    private var bag: DisposeBag
    private var delegate: UITextViewDelegate?
    
    private let radioBtnsViewModelBinder = StackViewToRadioBtnsViewModelBinder()
    private let radioBtnsWithInputViewModelBinder = StackViewToRadioBtnsWithInputViewModelBinder()
    private let checkboxBtnsViewModelBinder = StackViewToCheckboxBtnsViewModelBinder()
    private let checkboxBtnsWithInputViewModelBinder = StackViewToCheckboxBtnsWithInputViewModelBinder()
    private let switchBtnsViewModelBinder = StackViewToSwitchBtnsViewModelBinder()
    private let txtFieldViewModelBinder = TextFieldViewModelBinder()
    private let txtViewModelBinder = TextFieldWithOptionsViewModelBinder()
    
    init(viewFactory: ViewFactory, bag: DisposeBag, delegate: UITextViewDelegate?) {
        self.viewFactory = viewFactory
        self.bag = bag
        self.delegate = delegate
    }
    
    func drawStackView(singleQuestion: SingleQuestion, viewmodel: Questanable) -> ViewStacker {
        
        let question = singleQuestion.question
        //let viewmodel = parentViewmodel.childViewmodels[question.id]
        
        let height = getOneRowHeightFor(componentType: singleQuestion.question.type)
        let fr = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: viewFactory.bounds.width, height: height))
        
        var stackerView: ViewStacker!
        var btnViews: [UIView]
        switch question.type {
        case .radioBtn:
            
            let res = self.getRadioBtnsView(question: singleQuestion.question,
                                                          answer: singleQuestion.answer,
                                                          frame: fr)
            stackerView = res.0; btnViews = res.1
            
            radioBtnsViewModelBinder.hookUp(view: stackerView,
                                            btnViews: btnViews as! [RadioBtnView],
                                            viewmodel: viewmodel as! RadioViewModel,
                                            bag: bag)
        case .checkbox:
            let res = self.getCheckboxBtnsView(question: singleQuestion.question,
                                                             answer: singleQuestion.answer,
                                                             frame: fr)
            stackerView = res.0; btnViews = res.1
            
            checkboxBtnsViewModelBinder.hookUp(view: stackerView,
                                               btnViews: btnViews as! [CheckboxView],
                                               viewmodel: viewmodel as! CheckboxViewModel,
                                               bag: bag)
            
        case .radioBtnWithInput:
            let res = self.getRadioBtnsWithInputView(question: singleQuestion.question,
                                                                   answer: singleQuestion.answer,
                                                                   frame: fr)
            stackerView = res.0; btnViews = res.1
            
            radioBtnsWithInputViewModelBinder.hookUp(view: stackerView,
                                                     btnViews: btnViews as! [RadioBtnView],
                                                     viewmodel: viewmodel as! RadioWithInputViewModel,
                                                     bag: bag)
            
        case .checkboxWithInput:
            let res = self.getCheckboxBtnsWithInputView(question: singleQuestion.question,
                                                                      answer: singleQuestion.answer,
                                                                      frame: fr)
            stackerView = res.0; btnViews = res.1
            
            checkboxBtnsWithInputViewModelBinder.hookUp(view: stackerView,
                                                        btnViews: btnViews as! [CheckboxView],
                                                        viewmodel: viewmodel as! CheckboxWithInputViewModel,
                                                        bag: bag)
            
        case .switchBtn:
            let res = self.getSwitchBtns(question: singleQuestion.question,
                                         answer: singleQuestion.answer,
                                         frame: fr)
            stackerView = res.0; btnViews = res.1
            
            switchBtnsViewModelBinder.hookUp(view: stackerView,
                                             btnViews: btnViews as! [LabelBtnSwitchView],
                                             viewmodel: viewmodel as! SwitchBtnsViewModel,
                                             bag: bag)
        case .textField:
            let res = self.getLabelAndTextField(question: singleQuestion.question,
                                                answer: singleQuestion.answer,
                                                frame: fr)
            stackerView = res.0; btnViews = res.1
            
            txtFieldViewModelBinder.hookUp(view: stackerView,
                                           labelAndTextView: btnViews.first as! LabelAndTextField,
                                           viewmodel: viewmodel as! LabelWithTextFieldViewModel,
                                           bag: bag)
        case .textWithOptions:
            let res = self.getLabelAndTextView(question: singleQuestion.question,
                                                             answer: singleQuestion.answer,
                                                             frame: fr)
            stackerView = res.0; btnViews = res.1
            
            txtViewModelBinder.hookUp(view: stackerView,
                                      labelAndTextView: btnViews.first as! LabelAndTextView,
                                      viewmodel: viewmodel as! SelectOptionTextFieldViewModel,
                                      bag: bag)
            (btnViews.first as! LabelAndTextView).textView.sizeToFit()
            
            stackerView.resizeHeight(by: 20)
            
            (btnViews.first as! LabelAndTextView).textView.delegate = delegate
            
        default: break
        }
        
        return stackerView
        
    }
    
    func getRadioBtnsView(question: PresentQuestion, answer: Answering?, frame: CGRect) -> (ViewStacker, [RadioBtnView]) {
        
        let stackerView = viewFactory.getStackedRadioBtns(question: question, answer: answer, frame: frame)
        
        let btnViews = stackerView.components.flatMap { view -> [RadioBtnView] in
            return (view as? OneRowStacker)?.components as? [RadioBtnView] ?? [ ]
        }
        
        _ = btnViews.enumerated().map { $0.element.radioBtn.tag = $0.offset } // dodeli svakome unique TAG
        
        return (stackerView, btnViews)
        
    }
    
    func getCheckboxBtnsView(question: PresentQuestion, answer: Answering?, frame: CGRect) -> (ViewStacker, [CheckboxView]) {
    
        let stackerView = viewFactory.getStackedCheckboxBtns(question: question, answer: answer, frame: frame)
        
        let btnViews = stackerView.components.flatMap { view -> [CheckboxView] in
            return (view as? OneRowStacker)?.components as? [CheckboxView] ?? [ ]
        }
        
        _ = btnViews.enumerated().map { $0.element.radioBtn.tag = $0.offset } // dodeli svakome unique TAG
        
        return (stackerView, btnViews)
        
    }
    
    func getRadioBtnsWithInputView(question: PresentQuestion, answer: Answering?, frame: CGRect) -> (ViewStacker, [UIView]) {
        
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
    
    func getCheckboxBtnsWithInputView(question: PresentQuestion, answer: Answering?, frame: CGRect) -> (ViewStacker, [UIView]) {
        
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
    
    func getSwitchBtns(question: PresentQuestion, answer: Answering?, frame: CGRect) -> (ViewStacker, [UIView]) {
        
        let stackerView = viewFactory.getStackedSwitchBtns(question: question, answer: answer, frame: frame)
        
        let btnViews = stackerView.components.flatMap { view -> [LabelBtnSwitchView] in
            return (view as? OneRowStacker)?.components as? [LabelBtnSwitchView] ?? [ ]
        }
        
        _ = btnViews.enumerated().map { $0.element.switcher.tag = $0.offset } // dodeli svakome unique TAG
        
        return (stackerView, btnViews)
    }
    
    func getLabelAndTextField(question: PresentQuestion, answer: Answering?, frame: CGRect) -> (ViewStacker, [LabelAndTextField]) {
        
        //let stackerView = viewFactory.getStackedLblAndTextView(question: question, answer: answer, frame: frame)
        let stackerView = viewFactory.getStackedLblAndTextFieldView(questionWithAnswers: [(question, answer)], frame: frame)
        
        let views = stackerView.components.flatMap { view -> [LabelAndTextField] in
            return (view as? OneRowStacker)?.components as? [LabelAndTextField] ?? [ ]
        }
        
        _ = views.enumerated().map { $0.element.textField.tag = $0.offset } // dodeli svakome unique TAG
        
        return (stackerView, views)
        
    }
    
    // refactor ovo, mora biti samo 1 !!!
    func getLabelAndTextView(question: PresentQuestion, answer: Answering?, frame: CGRect) -> (ViewStacker, [LabelAndTextView]) {
        
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
