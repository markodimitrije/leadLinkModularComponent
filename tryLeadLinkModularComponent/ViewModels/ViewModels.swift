//
//  ViewModels.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 25/03/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class RadioViewModel: NSObject, ViewModelType, Questanable {
    
    var question: Question
    var answer: RadioAnswer?
    
    init(question: Question, answer: RadioAnswer?) {
        self.question = question
        self.answer = answer
    }
    
    struct Input {
        var ids: Observable<Int>
        var answer: RadioAnswer?
    }
    
    struct Output { // treba ti side effects
        var ids: Observable<Int> // tap koji mapiras u id (btn.tag)
    }
    
    func transform(input: Input) -> Output { // ovo je bas bezveze... razumi kako radi...
        
        let resulting = (answer == nil) ? input.ids : Observable.merge(Observable.of(answer!.optionId), input.ids)
        
        let output = Output.init(ids: resulting)
        
        return output
    }
    
    private var bag = DisposeBag()
}

class CheckboxViewModel: NSObject, ViewModelType, Questanable {
    
    var question: Question
    var answer: CheckboxAnswer?
    
    init(question: Question, answer: CheckboxAnswer?) {
        self.question = question
        self.answer = answer
    }
    
    struct Input {
        var ids: Observable<[Int]>
        var answer: CheckboxAnswer?
    }
    
    struct Output { // treba ti side effects
        var ids: Observable<[Int]> // tap koji mapiras u id (btn.tag)
    }
    
    func transform(input: Input) -> Output { // ovo je bas bezveze... razumi kako radi...
        
        let resulting = Observable.merge(Observable.of(answer?.optionId ?? [ ]), input.ids)
        
        let withAnswer = (answer == nil) ? input.ids : resulting
        
        let output = Output.init(ids: withAnswer)
        
        return output
    }
    
    private var bag = DisposeBag()
}

class RadioWithInputViewModel: NSObject, ViewModelType, Questanable {
    
    var question: Question
    var answer: RadioAnswer?
    
    init(question: Question, answer: RadioAnswer?) {
        self.question = question
        self.answer = answer
    }
    
    struct Input {
        var ids: Observable<Int>
        var optionTxt: Observable<String?>
        var answer: RadioAnswer?
    }
    
    struct Output { // treba ti side effects
        var ids: Observable<Int> // tap koji mapiras u id (btn.tag)
        var optionTxt: Observable<String?>
    }
    
    func transform(input: Input) -> Output { // ovo je bas bezveze... razumi kako radi...
        
        let resultingBtns = (answer == nil) ? input.ids : input.ids//Observable.merge(Observable.of(answer!.optionId), input.ids)
        
        let output = Output.init(ids: resultingBtns, optionTxt: input.optionTxt)
        
        return output
    }
    
    private var bag = DisposeBag()
}

class CheckboxWithInputViewModel: NSObject, ViewModelType, Questanable {
    
    var question: Question
    var answer: CheckboxAnswer?
    
    init(question: Question, answer: CheckboxAnswer?) {
        self.question = question
        self.answer = answer
    }
    
    struct Input {
        var ids: Observable<Int>
        var optionTxt: Observable<String?>
        var answer: CheckboxAnswer?
    }
    
    struct Output { // treba ti side effects
        var ids: Observable<Int> // tap koji mapiras u id (btn.tag)
        var optionTxt: Observable<String?>
    }
    
    func transform(input: Input) -> Output {
        
        let resultingBtns = (answer == nil) ? input.ids : input.ids
        
        let output = Output.init(ids: resultingBtns, optionTxt: input.optionTxt)
        
        return output
    }
    
    private var bag = DisposeBag()
}

class SwitchBtnsViewModel: NSObject, ViewModelType, Questanable {
    
    var question: Question
    var answer: SwitchAnswer?
    
    init(question: Question, answer: SwitchAnswer?) {
        self.question = question
        self.answer = answer
    }
    
    struct Input {
        var ids: Observable<[Int]>
        var answer: SwitchAnswer?
    }
    
    struct Output { // treba ti side effects
        var ids: Observable<[Int]> // tap koji mapiras u id (btn.tag)
    }
    
    func transform(input: Input) -> Output { // ovo je bas bezveze... razumi kako radi...
        
        let resulting = Observable.merge(Observable.of(answer?.optionId ?? [ ]), input.ids)
        
        let withAnswer = (answer == nil) ? input.ids : resulting
        
        let output = Output.init(ids: withAnswer)
        
        return output
    }
    
    private var bag = DisposeBag()
    
}

class LabelWithTextFieldViewModel: NSObject, ViewModelType, Questanable {
    
    var question: Question
    var answer: TextAnswer?
    
    init(question: Question, answer: TextAnswer?) {
        self.question = question
        self.answer = answer
    }
    
    struct Input {
        var content: Observable<[String]> // ovo su izabrane opcije, npr ["ita", "bra", "usa"...]
        var answer: TextAnswer?
    }
    
    struct Output { // treba ti side effects
        var content: Observable<[String]> // txt koji mapiras
    }
    
    func transform(input: Input) -> Output {
        
        let withAnswer = Observable.merge(Observable.of(answer?.content ?? [ ]), input.content)
        
        return Output.init(content: withAnswer)
    }
    
    private var bag = DisposeBag()
    
}

class SelectOptionTextFieldViewModel: NSObject, ViewModelType, Questanable {
    
    var question: Question
    var answer: OptionTextAnswer?
    
    init(question: Question, answer: OptionTextAnswer?) {
        self.question = question
        self.answer = answer
    }
    
    struct Input {
        var content: Observable<[String]> // ovo su izabrane opcije, npr ["ita", "bra", "usa"...]
        var answer: OptionTextAnswer?
    }
    
    struct Output { // treba ti side effects
        var content: Observable<[String]> // txt koji mapiras
    }
    
    func transform(input: Input) -> Output {
        
        let withAnswer = Observable.merge(Observable.of(answer?.content ?? [ ]), input.content)
        
        return Output.init(content: withAnswer)
    }
    
    private var bag = DisposeBag()
    
}
