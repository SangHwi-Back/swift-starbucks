//
//  UIStackView+Extensions.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/02/14.
//

import UIKit

extension UIStackView {
    func removeAllArrangedSubviews() {
        DispatchQueue.main.async {
            self.arrangedSubviews.forEach { view in
                self.removeArrangedSubview(view)
            }
        }
    }
}
