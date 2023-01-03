//
//  UIView+Extensions.swift
//  BeckBucks
//
//  Created by 백상휘 on 2022/09/29.
//

import UIKit

extension UIView {
    func setCornerRadius(_ radius: CGFloat? = nil) {
        self.layer.cornerRadius = radius ?? self.frame.height/4
        self.clipsToBounds = true
        self.setNeedsDisplay()
    }
    
    func putShadows(dx: CGFloat? = nil, dy: CGFloat? = nil, offset: CGSize? = nil) {
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 8
        
        if let offset {
            layer.shadowOffset = offset
        }
        
        if let dx, let dy {
            let shadowRect = bounds.offsetBy(dx: dx, dy: dy)
            layer.shadowPath = UIBezierPath(rect: shadowRect).cgPath
        }
    }
}
