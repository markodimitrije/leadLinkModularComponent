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
    struct Input {
        var id: Int
    }
    struct Output {
        var id: Int
    }
    func transform(input: RadioViewModel.Input) -> RadioViewModel.Output {
        let output = Output.init(id: input.id)
        print("prosledjujem input na output", input.id)
        return output
    }
}
