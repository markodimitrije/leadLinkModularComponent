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

protocol Questanable {
    var question: Question {get set}
}

extension RadioViewModel: Questanable {}
extension CheckboxViewModel: Questanable {}
extension RadioWithInputViewModel: Questanable {}
extension CheckboxWithInputViewModel: Questanable {}
