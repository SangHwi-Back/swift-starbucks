//
//  HTTPURLResponse+Extensions.swift
//  BeckBucks
//
//  Created by 백상휘 on 2022/11/24.
//

import Foundation

extension HTTPURLResponse {
  var isSuccess: Bool {
    (200..<300 ~= self.statusCode)
  }
}
