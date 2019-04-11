//
//  AnswerModel.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 11/04/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

protocol Answer {
    var questionId: Int {get set}
    var content: [String] {get set}
}

struct RadioAnswer: Answer {
    var questionId: Int // koji je ID pitanja
    var optionId: Int // koju opciju je izabrao
    var content = [String]() // koji je text te opcije
}

struct CheckboxAnswer: Answer {
    var questionId: Int // koji je ID pitanja
    var optionId: [Int] // koju opciju je izabrao - moze imati vise checkboxIds
    var content = [String]() // koji je text te opcije
}
struct SwitchAnswer: Answer {
    var questionId: Int // koji je ID pitanja
    var optionId: [Int] // koju opciju je izabrao - moze imati vise switchIds
    var content = [String]() // koji je text te opcije
}
struct OptionTextAnswer: Answer { // every TextAnswer is only it's on (stackView just shows them in one place)
    //    var multipleSelection: Bool - wrong solution
    var questionId: Int // koji je ID pitanja
    var content = [String]() // koji je od opcija izabrao (;1 ili vise njih; ako je izabrao sa searchVC)
}
struct TextAnswer: Answer {
    var questionId: Int // koji je ID pitanja
    var content = [String]()
    init(questionId: Int, content: [String]) {
        self.questionId = questionId
        self.content = content
    }
}
