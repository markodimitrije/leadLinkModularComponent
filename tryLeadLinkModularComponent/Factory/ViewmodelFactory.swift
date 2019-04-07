//
//  ViewmodelFactory.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 27/03/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

class ViewmodelFactory {

    func makeViewmodel(singleQuestion: SingleQuestion) -> Any {
        
        let question = singleQuestion.question
        let answer = singleQuestion.answer
        
        switch singleQuestion.question.type {
        case .radioBtn:
            return RadioViewModel.init(question: question, answer: answer as? RadioAnswer)
        case .checkbox:
            return CheckboxViewModel.init(question: question, answer: answer as? CheckboxAnswer)
        case .radioBtnWithInput:
            return RadioWithInputViewModel.init(question: question, answer: answer as? RadioAnswer)
        case .checkboxWithInput:
            return CheckboxWithInputViewModel.init(question: question, answer: answer as? CheckboxAnswer)
        case .switchBtn:
            return SwitchBtnsViewModel.init(question: question, answer: answer as? SwitchAnswer)
        case .textField:
            return LabelWithTextFieldViewModel.init(question: question, answer: answer as? TextAnswer)
        case .textWithOptions:
            return SelectOptionTextFieldViewModel.init(question: question, answer: answer as? OptionTextAnswer)
        default:
            fatalError("ViewmodelFactory/makeViewmodel/no supported type")
        }

    }
        
}
