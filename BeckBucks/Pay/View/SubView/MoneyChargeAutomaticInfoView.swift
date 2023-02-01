//
//  MoneyChargeAutomaticInfoView.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/02/01.
//

import UIKit

class MoneyChargeAutomaticInfoView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        guard let viewFromNib = loadViewFromNib() else {
            return
        }
        
        addSubview(viewFromNib)
        viewFromNib.frame = CGRect(origin: .zero, size: frame.size)
    }
}
