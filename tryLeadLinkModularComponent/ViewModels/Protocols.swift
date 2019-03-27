//
//  Protocols.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 24/12/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol RowsStackedEqually {
    //
}

protocol ViewModelType: Hashable {
    associatedtype Input
    associatedtype Output
    func transform(input: Input) -> Output
}
