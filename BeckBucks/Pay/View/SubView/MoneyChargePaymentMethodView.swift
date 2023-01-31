//
//  MoneyChargePaymentMethodView.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/31.
//

import UIKit

class MoneyChargePaymentMethodView: UIView {
    
    var selectedIndex: Int = 0
    
    @IBOutlet weak var setCreditCardButton: UIButton!
    
    @IBOutlet weak var setSSGPAYButton: UIButton!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        guard let viewFromNib = loadViewFromNib() else {
            return
        }
        
        self.addSubview(viewFromNib)
        viewFromNib.frame = CGRect(origin: .zero, size: frame.size)
        
        setCreditCardButton.imageView?
            .tintColor = UIColor(named: "starbucks_green_light")
        setSSGPAYButton.imageView?
            .tintColor = UIColor(named: "starbucks_green_light")
    }
}
