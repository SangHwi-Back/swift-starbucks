//
//  UITableViewCell+Extensions.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/31.
//

import UIKit

extension UITableViewCell {
    static var reusableIdentifier: String {
        String(describing: Self.self)
    }
}
