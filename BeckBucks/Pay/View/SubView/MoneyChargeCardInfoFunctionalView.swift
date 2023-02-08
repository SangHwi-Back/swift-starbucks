//
//  MoneyChargeCardInfoFunctionalView.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/02/01.
//

import UIKit
import RxSwift

class MoneyChargeCardInfoFunctionalView: UIView {
    
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var cardTitleLabel: UILabel!
    @IBOutlet weak var chargeNowButton: UIButton!
    @IBOutlet weak var chargeStateButton: UIButton!
    @IBOutlet weak var cardBalanceLabel: UILabel!
    
    private var formatter = NumberFormatter()
    var autoChargeAmountSubject = PublishSubject<Float>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        formatter.numberStyle = .decimal
        formatter.currencyDecimalSeparator = " "
        
        guard let viewFromNib = loadViewFromNib() else {
            return
        }
        
        addSubview(viewFromNib)
        viewFromNib.frame = CGRect(origin: .zero, size: frame.size)
    }
    
    func setCardInformation(_ entity: CardInformation) {
        cardImageView.image = UIImage(named: entity.card_name)
        cardTitleLabel.text = entity.name
        setBalance(entity.balance, currencyCode: entity.currency)
    }
    
    func setBalance(_ num: Float, currencyCode: String) {
        let balance = formatter.string(from: NSNumber(value: num)) ?? "0"
        let currencySymbol = Locale(identifier: currencyCode).currencySymbol ?? ""
        cardBalanceLabel.text = (balance + currencySymbol)
    }
}
