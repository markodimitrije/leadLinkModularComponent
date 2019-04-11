//
//  GlobalFuncs.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 11/04/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

func getOneRowHeightFor(componentType type: QuestionType) -> CGFloat {
    switch type {
    // sta sa textArea ?
    case .textField:
        return CGFloat.init(80)
    case .radioBtn:
        return CGFloat.init(50)
    case .checkbox:
        return CGFloat.init(50)
    case .radioBtnWithInput:
        return CGFloat.init(50)
    case .checkboxWithInput:
        return CGFloat.init(50)
    case .switchBtn:
        return CGFloat.init(50)
    default:
        return 0.0
    }
}
