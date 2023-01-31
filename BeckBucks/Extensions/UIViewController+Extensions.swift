//
//  UIViewController+Extensions.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/31.
//

import UIKit

extension UIViewController {
    static var storyboardIdentifier: String {
        String(describing: Self.self)
    }
}
