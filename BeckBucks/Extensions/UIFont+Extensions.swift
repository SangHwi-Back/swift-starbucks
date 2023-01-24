//
//  UIFont+Extensions.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/13.
//

import UIKit

extension UIFont {
    
    static var titleCellFont: UIFont {
        UIFont.systemFont(ofSize: 17, weight: .bold)
    }
    
    static var listTitleFont: UIFont {
        UIFont.systemFont(ofSize: 12, weight: .semibold)
    }
    
    static var subListTitleFont: UIFont {
        UIFont.systemFont(ofSize: 12, weight: .regular)
    }
    
    static var priceTagFont: UIFont {
        UIFont.systemFont(ofSize: 12, weight: .semibold)
    }
}
