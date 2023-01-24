//
//  OrderMyMenuTableViewCell.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/21.
//

import UIKit
import RxSwift
import RxCocoa

class OrderMyMenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var menuImageView: UIImageView!
    
    @IBOutlet weak var removeButton: UIButton!
    
    @IBOutlet weak var editTitleButton: UIButton!
    @IBOutlet weak var menuTitleLabel: LabelWithSFSymbol!
    @IBOutlet weak var engTitleLabel: UILabel!
    @IBOutlet weak var priceTagLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var insertMyBagButton: UIButton!
    @IBOutlet weak var orderMenuButton: UIButton!
    
    let formatter = NumberFormatter()
    
    private var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        insertMyBagButton.layer.borderWidth = 1
        insertMyBagButton.layer.borderColor = UIColor.green.cgColor
        insertMyBagButton.backgroundColor = .white
        
        orderMenuButton.backgroundColor = .systemGreen
        
        insertMyBagButton.titleLabel?.textColor = .systemGreen
        orderMenuButton.titleLabel?.textColor = .white
        
        formatter.numberStyle = .decimal
        
        insertMyBagButton.setCornerRadius()
        orderMenuButton.setCornerRadius()
        menuImageView.setCornerRadius()
        
        editTitleButton.rx.tap
            .bind(onNext: {
                print("")
            })
            .disposed(by: disposeBag)
    }
    
    func setDisabled(_ disabled: Bool) {
        
        menuImageView.image = nil
        
        priceTagLabel.text = "판매 종료"
        priceTagLabel.textColor = disabled ? .red : .label
        descriptionLabel.text = nil
        
        insertMyBagButton.layer.borderColor = disabled ? UIColor.systemGray4.cgColor : UIColor.systemGreen.cgColor
        insertMyBagButton.titleLabel?.textColor = disabled ? UIColor.systemGreen : UIColor.systemGray4
    }
    
    func setPrice(_ price: Int) {
        guard let decimalText = formatter.string(from: NSNumber(value: price)) else {
            return
        }
        
        priceTagLabel.text = decimalText + "원"
    }
}
