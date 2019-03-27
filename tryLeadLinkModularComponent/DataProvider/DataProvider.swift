//
//  DataProvider.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 23/03/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

class QuestionsDataProvider {
    var questions = [SingleQuestion]()
    init(campaignId: Int) {
        // fetch iz realm by this: campaignId
        guard let first = SingleQuestion.init(forQuestion: 0),
            let second = SingleQuestion.init(forQuestion: 1),
            let third = SingleQuestion.init(forQuestion: 2),
            let fourth = SingleQuestion.init(forQuestion: 3) else {
                return
        }
        questions = [first, second, third, fourth]
    }
}

class SingleQuestion {
    var question: Question
    var answer: Answer?
    
    init?(forQuestion id: Int) {
        switch id {
        case 0:
            let options = ["Paris", "London", "Maroco", "Madrid", "Moscow"]
            let q = Question.init(id: 3, type: "radioBtn", headlineText: "Headline", inputTxt: "whatever", options: options)
            let answer = RadioAnswer.init(questionId: q.id, optionId: 3, content: ["Madrid"]) // ovo ces izvuci iz REALM-a! ili dataLayer-a
            (self.question, self.answer) = (q, answer)
        case 1:
            let options = ["Soccer", "Basketball", "Swimming", "Tennis", "Waterpolo", "Car racing"]
            let q = Question.init(id: 2, type: "checkbox", headlineText: "Sports", inputTxt: "whatever", options: options)
            // ovo ces izvuci iz REALM-a! ili dataLayer-a:
            let answer = CheckboxAnswer.init(questionId: q.id, optionId: [1,2,3,4], content: ["Basketball", "Swimming", "Tennis", "Waterpolo"])
            (self.question, self.answer) = (q, answer)
            
        case 2:
            let options = ["Paris", "London", "Maroco", "Madrid", "Moscow"]
            let q = Question.init(id: 22, type: "radioBtnWithInput", headlineText: "Headline", inputTxt: "whatever", options: options)
            let answer = RadioAnswer.init(questionId: q.id, optionId: 5, content: ["Palermo"]) // ovo ces izvuci iz REALM-a!...
            (self.question, self.answer) = (q, answer)
        
        case 3:
            let options = ["Apple", "Pear", "Other"]
            let q = Question.init(id: 2, type: "checkboxWithOption", headlineText: "Fruits", inputTxt: "Choose your favourite", options: options)
            // ovo ces izvuci iz REALM-a! ili dataLayer-a:
            let answer = CheckboxAnswer.init(questionId: q.id, optionId: [3], content: ["Coconut"])
            (self.question, self.answer) = (q, answer)
            
        default: return nil
            
        }
    }
    
}
