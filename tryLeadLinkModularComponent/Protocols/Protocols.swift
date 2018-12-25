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
    }
    
    func transform(input: RadioViewModel.Input) -> RadioViewModel.Output {
        
//        let activeSignal: Driver<Int>
//        let inactiveSignal: [Driver<Int>]
        
//        func todo() {
//            input.ids.subscribe(onNext: { (<#Int#>) in
//                
//            })
//        }
//        
//        input.ids.asDriver(onErrorJustReturn: 0).do(onNext: { (<#Int#>) in
//            
//        })

        let output = Output.init(ids: input.ids)
        print("prosledjujem input na output", output.ids)
        return output
    }
}
