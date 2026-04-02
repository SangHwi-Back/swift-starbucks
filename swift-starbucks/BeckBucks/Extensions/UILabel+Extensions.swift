//
//  UILabel+Extensions.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/13.
//

import UIKit

extension UILabel {
    func mutateListTitleStyleLabel() {
        self.font = UIFont.listTitleFont
        self.textColor = .label
        self.setNeedsDisplay()
    }
    
    func mutateListSubTitleStyleLabel() {
        self.font = UIFont.subListTitleFont
        self.textColor = UIColor(named: "color_text_gray_2")
        self.setNeedsDisplay()
    }
    
    func mutatePriceTagStyleLabel() {
        self.font = UIFont.priceTagFont
        self.textColor = .label
        self.setNeedsDisplay()
    }
}
