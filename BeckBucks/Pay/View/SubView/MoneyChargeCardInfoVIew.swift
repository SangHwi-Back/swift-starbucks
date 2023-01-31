//
//  MoneyChargeCardInfoVIew.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/31.
//

import UIKit

class MoneyChargeCardInfoVIew: UIView {
    
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var cardTitleLabel: UILabel!
    @IBOutlet weak var cardBalanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        guard let viewFromNib = loadViewFromNib() else {
            return
        }
        
        self.addSubview(viewFromNib)
        viewFromNib.frame = CGRect(origin: .zero, size: frame.size)
    }
}
