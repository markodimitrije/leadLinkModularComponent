//
//  Protocols.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 24/12/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import Foundation

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
        var id: Int
        var ids = [Int]()
    }
    struct Output {
        var id: Int
        var ids = [Int]()
    }
    func transform(input: RadioViewModel.Input) -> RadioViewModel.Output {
        let output = Output.init(id: input.id, ids: input.ids)
        print("prosledjujem input na output", input.id)
        return output
    }
}
