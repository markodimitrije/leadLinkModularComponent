//
//  LeadLinkKitError.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 30/12/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import Foundation

enum LeadLinkKitError: Error {
    case any
}

enum ApiError: Error {
    case invalidJson
    case invalidKey
    case cityNotFound
    case serverFailure
}

enum PersmissionError: Error {
    case denied
}
