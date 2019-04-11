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
    
    init(viewFactory: ViewFactory, bag: DisposeBag) {
        self.viewFactory = viewFactory
        self.bag = bag
    }
    
    // hocu da Tap na embeded radio btn (nalazi se digged in u ViewStacker-u) pogoni ostale btn-e da menjaju sliku + da save actual za MODEL
    // s druge strane, ANSWER bi trebalo da pogoni sve btns, jer moze da se upari i preko "id" i preko "value"
    
     func getRadioBtnsView(question: Question, answer: Answer?, frame: CGRect) -> (ViewStacker, [RadioBtnView]) {
        
        let stackerView = viewFactory.getStackedRadioBtns(question: question, answer: answer, frame: frame)
        
        let btnViews = stackerView.components.flatMap { view -> [RadioBtnView] in
            return (view as? OneRowStacker)?.components as? [RadioBtnView] ?? [ ]
        }
        
        _ = btnViews.enumerated().map { $0.element.radioBtn.tag = $0.offset } // dodeli svakome unique TAG
        
        return (stackerView, btnViews)
        
    }
    
    func getCheckboxBtnsView(question: Question, answer: Answer?, frame: CGRect) -> (ViewStacker, [CheckboxView]) {
    
        let stackerView = viewFactory.getStackedCheckboxBtns(question: question, answer: answer, frame: frame)
        
        let btnViews = stackerView.components.flatMap { view -> [CheckboxView] in
            return (view as? OneRowStacker)?.components as? [CheckboxView] ?? [ ]
        }
        
        _ = btnViews.enumerated().map { $0.element.radioBtn.tag = $0.offset } // dodeli svakome unique TAG
        
        return (stackerView, btnViews)
        
    }
    
    func getRadioBtnsWithInputView(question: Question, answer: Answer?, frame: CGRect) -> (ViewStacker, [UIView]) {
        
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
    
    func getCheckboxBtnsWithInputView(question: Question, answer: Answer?, frame: CGRect) -> (ViewStacker, [UIView]) {
        
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
    
    func getSwitchBtns(question: Question, answer: Answer?, frame: CGRect) -> (ViewStacker, [UIView]) {
        
        let stackerView = viewFactory.getStackedSwitchBtns(question: question, answer: answer, frame: frame)
        
        let btnViews = stackerView.components.flatMap { view -> [LabelBtnSwitchView] in
            return (view as? OneRowStacker)?.components as? [LabelBtnSwitchView] ?? [ ]
        }
        
        _ = btnViews.enumerated().map { $0.element.switcher.tag = $0.offset } // dodeli svakome unique TAG
        
        return (stackerView, btnViews)
    }
    
    func getLabelAndTextField(question: Question, answer: Answer?, frame: CGRect) -> (ViewStacker, [LabelAndTextField]) {
        
        //let stackerView = viewFactory.getStackedLblAndTextView(question: question, answer: answer, frame: frame)
        let stackerView = viewFactory.getStackedLblAndTextFieldView(questionWithAnswers: [(question, answer)], frame: frame)
        
        let views = stackerView.components.flatMap { view -> [LabelAndTextField] in
            return (view as? OneRowStacker)?.components as? [LabelAndTextField] ?? [ ]
        }
        
        _ = views.enumerated().map { $0.element.textField.tag = $0.offset } // dodeli svakome unique TAG
        
        return (stackerView, views)
        
    }
    
    // refactor ovo, mora biti samo 1 !!!
    func getLabelAndTextView(question: Question, answer: Answer?, frame: CGRect) -> (ViewStacker, [LabelAndTextView]) {
        
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
