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
    
    init(question: Question) {
        self.question = question
    }
    
    struct Input {
        var ids: Observable<Int>
    }
    
    struct Output { // treba ti side effects
        var ids: Observable<Int> // tap koji mapiras u id (btn.tag)
        var active: Int? // tap koji mapiras u id (btn.tag)
        var act: BehaviorRelay<Int?>
    }
    
    func transform(input: RadioViewModel.Input) -> RadioViewModel.Output {
        
        let act = BehaviorRelay<Int?>(value: nil)
        let inact = BehaviorRelay<[Int]>.init(value: [ ])
        
        var active: Int?
        
            input.ids.takeLast(1)
            .subscribe(onNext: { val in
                active = val
                act.accept(val)
            })
            .disposed(by: bag)

        let output = Output.init(ids: input.ids, active: active, act: act)
        
        return output
    }
    
    private var bag = DisposeBag()
}
