//
//  MyRxExtensions.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 26/12/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
//
//protocol OptionTxtUpdatable {
//    var optionText: Binder<String> {get set}
//}
//
////
////extension UITextField: OptionTxtUpdatable {
////
////}

//
//extension Reactive where Base: UITextField { (******)
//
//    var optionText: Binder<String> { (******)
//        return Binder.init(self.base, binding: { (view, value) in
//            view.text = value
//        })
//    }
//
//}

protocol OptionTxtUpdatable {
    // trebalo bi napisati tako da namece uslov: (******)
    var optionTxt: Binder<String> {get}
}

extension UITextField: OptionTxtUpdatable {
    var optionTxt: Binder<String> {
        return self.rx.optionTxt
    }
}

extension RadioBtnView: OptionTxtUpdatable {
    var optionTxt: Binder<String> {
        return self.rx.optionTxt
    }
}

extension Reactive where Base: UITextField {
    var optionTxt: Binder<String> {
        return Binder.init(self.base, binding: { (view, value) in
            view.text = value
        })
    }
}

