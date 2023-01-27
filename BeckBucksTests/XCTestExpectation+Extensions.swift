//
//  XCTestExpectation+Extensions.swift
//  BeckBucksTests
//
//  Created by 백상휘 on 2023/01/27.
//

import XCTest

extension XCTestExpectation {
    static func withCount(_ count: UInt) -> XCTestExpectation {
        let result = XCTestExpectation()
        result.expectedFulfillmentCount = Int(count)
        return result
    }
}
