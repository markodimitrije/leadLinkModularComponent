//
//  ParentViewModel.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 25/03/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

class ParentViewModel {
    var childViewmodels = [Questanable]()
    init(viewmodels: [Questanable]) {
        self.childViewmodels = viewmodels
    }
}

class Smth {
    static func test() {
        guard let first = SingleQuestion.init(forQuestion: 0),
            let second = SingleQuestion.init(forQuestion: 1),
            let third = SingleQuestion.init(forQuestion: 2) else {return}
        
        let rvm = RadioViewModel.init(question: first.question, answer: nil)
        let chvm = CheckboxViewModel.init(question: second.question, answer: nil)
        let rvmInput = RadioWithInputViewModel.init(question: third.question, answer: nil)
        let parentViewmodel = ParentViewModel.init(viewmodels: [rvm, chvm, rvmInput])
        _ = parentViewmodel.childViewmodels.map { vm -> Void in
            print("question = \(vm.question)")
        }
    }
}

protocol Questanable {
    var question: Question {get set}
}

extension RadioViewModel: Questanable {}
extension CheckboxViewModel: Questanable {}
extension RadioWithInputViewModel: Questanable {}
