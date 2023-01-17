//
//  MyBagListTableViewItemCell.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/15.
//

import UIKit
import RxCocoa
import RxSwift

class MyBagListTableViewItemCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var desciptionLabel: UILabel!
    @IBOutlet weak var pricePerUnitWithOptionsLabel: UILabel!
    @IBOutlet weak var unitCountMinusButton: UIButton!
    @IBOutlet weak var unitCountLabel: UILabel!
    @IBOutlet weak var unitCountPlusButton: UIButton!
    @IBOutlet weak var priceSumLabel: UILabel!
    
    var disposeBag = DisposeBag()
    var entity: MyBagFoodData?
    
    var pricePerUnit: NSNumber {
        NSNumber(floatLiteral: Double(entity?.pricePerUnit ?? 0.0))
    }
    
    var priceNumberFormatter: NumberFormatter = {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.roundingMode = .down
        formatter.allowsFloats = false
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
    
    let unitCountBehaviorRelay = BehaviorRelay(value: 1)
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setUI() {
        titleLabel.text = entity?.title
        subTitleLabel.text = entity?.engTitle
        desciptionLabel.text = entity?.description
        pricePerUnitWithOptionsLabel.text = priceNumberFormatter.string(from: pricePerUnit)
        priceSumLabel.text = priceNumberFormatter.string(from: pricePerUnit)
        bindUI()
    }
    
    private func bindUI() {
        
        unitCountBehaviorRelay
            .map({ String($0) })
            .bind(to: unitCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        unitCountBehaviorRelay
            .map({ unitCount -> String? in
                let sum = NSNumber(value: unitCount * self.pricePerUnit.intValue)
                return self.priceNumberFormatter.string(from: sum)
            })
            .bind(to: priceSumLabel.rx.text)
            .disposed(by: disposeBag)
        
        unitCountMinusButton.rx.tap
            .do(afterNext: {
                let value = self.unitCountBehaviorRelay.value
                self.unitCountMinusButton.isUserInteractionEnabled = value != 0
                self.unitCountPlusButton.isUserInteractionEnabled = value != 20
            })
            .bind(onNext: {
                let current = self.unitCountBehaviorRelay.value
                guard current >= 1 else { return }
                self.unitCountBehaviorRelay.accept(current - 1)
            })
            .disposed(by: disposeBag)
                
        unitCountPlusButton.rx
            .tap
            .do(afterNext: {
                let value = self.unitCountBehaviorRelay.value
                self.unitCountMinusButton.isUserInteractionEnabled = value != 0
                self.unitCountPlusButton.isUserInteractionEnabled = value != 20
            })
            .bind(onNext: {
                let current = self.unitCountBehaviorRelay.value
                guard current < 20 else { return }
                self.unitCountBehaviorRelay.accept(current + 1)
            })
            .disposed(by: disposeBag)
    }
}
