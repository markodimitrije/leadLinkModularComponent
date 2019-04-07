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
        guard //let radio = SingleQuestion.init(forQuestion: 0),
//            let checkbox = SingleQuestion.init(forQuestion: 1),
//            let radioWithInput = SingleQuestion.init(forQuestion: 2),
//            let checkboxWithInput = SingleQuestion.init(forQuestion: 3),
//            let checkbox = SingleQuestion.init(forQuestion: 4),
//            let txtField = SingleQuestion.init(forQuestion: 5) else {
            let txtWithOptionsView = SingleQuestion.init(forQuestion: 7) else {
                return
        }
        //questions = [radio, checkbox, radioWithInput, checkboxWithInput, switchBtns, txtField]
        questions = [txtWithOptionsView]
    }
}

class SingleQuestion {
    var question: Question
    var answer: Answer?
    
    init?(forQuestion id: Int) {
        switch id {
        case 0:
            let options = ["Paris", "London", "Maroco", "Madrid", "Moscow"]
            let q = Question.init(id: 12, type: QuestionType.radioBtnWithInput, headlineText: "Headline", inputTxt: "whatever", options: options)
            let answer = RadioAnswer.init(questionId: q.id, optionId: 5, content: ["Palermo"]) // ovo ces izvuci iz REALM-a!...
            (self.question, self.answer) = (q, answer)
        
        case 1:
            let options = ["Apple", "Pear", "Other"]
            let q = Question.init(id: 77, type: QuestionType.checkboxWithInput, headlineText: "Fruits", inputTxt: "Choose your favourite", options: options)
            // ovo ces izvuci iz REALM-a! ili dataLayer-a:
            let answer = CheckboxAnswer.init(questionId: q.id, optionId: [3], content: ["Coconut"])
            (self.question, self.answer) = (q, answer)
        case 2:
            let options = ["Red","Green","Blue","Terms and conditions"]
            let q = Question.init(id: 177, type: QuestionType.switchBtn, headlineText: "Preferences", inputTxt: "Choose your preferences", options: options)
            // ovo ces izvuci iz REALM-a! ili dataLayer-a:
            let answer = SwitchAnswer.init(questionId: q.id, optionId: [2], content: ["Blue"])
            (self.question, self.answer) = (q, answer)
            //(self.question, self.answer) = (q, nil) // test....
        case 3:
            let options = ["Paris", "London", "Maroco", "Madrid", "Moscow"]
            let q = Question.init(id: 3, type: QuestionType.radioBtn, headlineText: "Headline", inputTxt: "whatever", options: options)
            let answer = RadioAnswer.init(questionId: q.id, optionId: 3, content: ["Madrid"]) // ovo ces izvuci iz REALM-a! ili dataLayer-a
            (self.question, self.answer) = (q, answer)
        case 4:
            let options = ["Soccer", "Basketball", "Swimming", "Tennis", "Waterpolo", "Car racing"]
            let q = Question.init(id: 2, type: QuestionType.checkbox, headlineText: "Sports", inputTxt: "whatever", options: options)
            // ovo ces izvuci iz REALM-a! ili dataLayer-a:
            let answer = CheckboxAnswer.init(questionId: q.id, optionId: [1,2,3,4], content: ["Basketball", "Swimming", "Tennis", "Waterpolo"])
            (self.question, self.answer) = (q, answer)
        case 5:
            let q = Question.init(id: 10, type: QuestionType.textField, headlineText: "First name", inputTxt: "type your name", options: [ ])
            let answer = TextAnswer.init(questionId: 10, content: ["Jollene"])
            (self.question, self.answer) = (q, answer)
//        case 6:
//            let options = [String]()
//            let q = Question.init(id: 33, type: QuestionType.textField, headlineText: "Last name", inputTxt: "type your name", options: options)
//        (self.question, self.answer) = (q, nil)
        case 7:
            let options = ["Lion", "Snake", "Bird", "Orca", "Dog", "Cat", "Wolf", "Whale" , "Dolphin", "Monkey", "Bee", "Eagle"]
            let q = Question.init(id: 44, type: QuestionType.textWithOptions, headlineText: "Your pets", inputTxt: "Select your pets", options: options)
            //let answer = TextAnswer.init(questionId: 44, content: ["Bird", "Dog"])
            let answer = OptionTextAnswer.init(multipleSelection: true, questionId: 44, content: ["Bird", "Dog"])
            (self.question, self.answer) = (q, answer)
        default: return nil
            
        }
    }
    
}
