//
//  Protocols.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 24/12/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol RowsStackedEqually {
    //
}

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    func transform(input: Input) -> Output
}

class RadioViewModel: ViewModelType {
    
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
        
        //let withAnswer = (answer == nil) ? input.ids : resulting
        
        //let output = Output.init(ids: withAnswer)\
        
        let output = Output.init(ids: resulting)
        
        return output
    }
    
    private var bag = DisposeBag()
}


class CheckboxViewModel: ViewModelType {
    
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
