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
  
  func putShadows(dx: CGFloat = 5, dy: CGFloat = 5) {
    let shadowRect = bounds.offsetBy(dx: dx, dy: dy)
    
    layer.shadowColor = UIColor.lightGray.cgColor
    layer.shadowOpacity = 0.5
    layer.shadowRadius = 8
    layer.shadowOffset = .zero
    layer.shadowPath = UIBezierPath(rect: shadowRect).cgPath
  }
}
