//
//  MoneyChargeDefinedChargeAmountView.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/31.
//

import UIKit
import RxSwift
import RxCocoa

class MoneyChargeDefinedChargeAmountView: UIView {
    
    private var selectedIndex = 0
    
    @IBOutlet var buttonStacks: [UIStackView]!
    @IBOutlet var amountButtons: [UIButton]!
    
    @IBOutlet weak var oneButton: UIButton!
    @IBOutlet weak var threeButton: UIButton!
    @IBOutlet weak var fiveButton: UIButton!
    @IBOutlet weak var sevenButton: UIButton!
    @IBOutlet weak var tenButton: UIButton!
    @IBOutlet weak var otherButton: UIButton!
    
    private var disposeBag = DisposeBag()
    
    var chargeAmountSubject = PublishSubject<Float>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        guard let viewFromNib = loadViewFromNib() else {
            return
        }
        
        self.addSubview(viewFromNib)
        viewFromNib.frame = CGRect(origin: .zero, size: frame.size)
        
        amountButtons.forEach(makeButtonRound)
        
        Observable<Int>
            .merge([
                oneButton.rx.tap.map({1}),
                threeButton.rx.tap.map({2}),
                fiveButton.rx.tap.map({3}),
                sevenButton.rx.tap.map({4}),
                tenButton.rx.tap.map({5}),
                otherButton.rx.tap.map({0}),
            ])
            .bind(onNext: { [weak self] num in
                self?.selectedIndex = num
                self?.changeButtonSelected(at: num)
                self?.chargeAmountSubject.onNext(Float(num * 10000))
            })
            .disposed(by: disposeBag)
    }
    
    func makeButtonRound(_ button: UIButton) {
        button.setCornerRadius(4)
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.layer.borderWidth = 1
    }
    
    func changeButtonSelected(at index: Int) {
        guard index < amountButtons.count else { return }

        self.selectedIndex = index
        self.isUserInteractionEnabled = false

        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let buttons = self?.amountButtons else { return }
            for i in 0..<buttons.count {
                
                let isTarget = i == self?.selectedIndex
                let backgroundColor = isTarget ? UIColor(named: "starbucks_green_light") : .white
                let borderColor = isTarget ? UIColor.clear.cgColor : UIColor.darkGray.cgColor
                let tintColor = isTarget ? .white : UIColor(named: "color_text_gray")
                
                buttons[i].backgroundColor = backgroundColor
                buttons[i].layer.borderColor = borderColor
                buttons[i].tintColor = tintColor
            }
        } completion: { [weak self] _ in
            self?.isUserInteractionEnabled = true
        }
    }
}
