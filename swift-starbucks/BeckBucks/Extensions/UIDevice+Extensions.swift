//
//  UIDevice+Extensions.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/27.
//

import UIKit

extension UIDevice {
    var hasNotch: Bool {
        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}
