//
//  ViewFromNib.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/31.
//

import UIKit

class ViewFromNib: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        guard let viewFromNib = loadViewFromNib() else {
            return
        }
        
        self.addSubview(viewFromNib)
        viewFromNib.frame = self.frame
    }
}
