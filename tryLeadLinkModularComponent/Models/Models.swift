//
//  Models.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 11/04/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

// QuestionType

struct Question {
    var id: Int
    var type: QuestionType
    var headlineText = ""
    var inputTxt = ""
    var options = [String]()
    var multipleSelection = false
}

enum InternalError: Error {
    case viewmodelConversion
}
