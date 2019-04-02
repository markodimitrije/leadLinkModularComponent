//
//  RxViewModel.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 26/03/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//


import RxSwift
import RxCocoa

extension Reactive where Base: RadioViewModel {
    internal var optionSelected: Binder<Int> {
        return Binder.init(self.base, binding: { (viewmodel, index) in
            let optionTxt = viewmodel.question.options[index]
            let newAnswer = RadioAnswer.init(questionId: self.base.question.id, optionId: index, content: [optionTxt])
            viewmodel.answer = newAnswer
        })
    }
}

extension Reactive where Base: CheckboxViewModel {
    internal var optionSelected: Binder<[Int]> {
        return Binder.init(self.base, binding: { (viewmodel, indexes) in
            
            let newContent = viewmodel.question.options.enumerated().filter({ (index, element) -> Bool in
                return indexes.contains(index)
            }).map({ (_, element) -> String in
                return element
            })
            
            let newAnswer = CheckboxAnswer.init(questionId: viewmodel.question.id,
                                                optionId: indexes,
                                                content: newContent)
            viewmodel.answer = newAnswer
        })
    }
}

extension Reactive where Base: RadioWithInputViewModel {
    internal var optionSelected: Binder<Int> {
        return Binder.init(self.base, binding: { (viewmodel, index) in
            let optionTxt = viewmodel.question.options[index]
            let newAnswer = RadioAnswer.init(questionId: self.base.question.id, optionId: index, content: [optionTxt])
            viewmodel.answer = newAnswer
        })
    }
    internal var txtChanged: Binder<String> {
        return Binder.init(self.base, binding: { (viewmodel, value) in
            let options = viewmodel.question.options
            guard let lastOption = options.last,
                let lastIndex = options.lastIndex(of: lastOption) else {return}
            let newAnswer = RadioAnswer.init(questionId: self.base.question.id, optionId: lastIndex, content: [value])
            viewmodel.answer = newAnswer
        })
    }
}

// single selection choice
extension Reactive where Base: CheckboxWithInputViewModel {
    internal var optionSelected: Binder<Int> {
        return Binder.init(self.base, binding: { (viewmodel, index) in
            let optionTxt = viewmodel.question.options[index]
            let newAnswer = CheckboxAnswer.init(questionId: self.base.question.id, optionId: [index], content: [optionTxt])
            viewmodel.answer = newAnswer
        })
    }
    internal var txtChanged: Binder<String> {
        return Binder.init(self.base, binding: { (viewmodel, value) in
            let options = viewmodel.question.options
            guard let lastOption = options.last,
                let lastIndex = options.lastIndex(of: lastOption) else {return}
            let newAnswer = CheckboxAnswer.init(questionId: self.base.question.id, optionId: [lastIndex], content: [value])
            viewmodel.answer = newAnswer
        })
    }
}

extension Reactive where Base: SwitchBtnsViewModel {
    internal var optionSelected: Binder<[Int]> {
        return Binder.init(self.base, binding: { (viewmodel, indexes) in
            
            let newContent = viewmodel.question.options.enumerated().filter({ (index, element) -> Bool in
                return indexes.contains(index)
            }).map({ (_, element) -> String in
                return element
            })
            
            let newAnswer = SwitchAnswer.init(questionId: viewmodel.question.id,
                                              optionId: indexes,
                                              content: newContent)
            print("viewmodel dobija answer = \(newAnswer)")
            viewmodel.answer = newAnswer
        })
    }
}
