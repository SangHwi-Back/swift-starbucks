//
//  URL+Extensions.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/27.
//

import Foundation

extension Optional where Wrapped == URL {
    var getErrorMessage: String {
        ("Error occured at " + (self?.absoluteString ?? "unkown URL") + ".")
    }
}
