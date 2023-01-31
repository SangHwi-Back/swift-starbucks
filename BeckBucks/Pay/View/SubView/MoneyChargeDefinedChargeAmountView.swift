//
//  MoneyChargeDefinedChargeAmountView.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/31.
//

import UIKit

class MoneyChargeDefinedChargeAmountView: UIView {
    
    private var selectedIndex = 0
    
    @IBOutlet var buttonStacks: [UIStackView]!
    
    @IBOutlet var amountButtons: [UIButton]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        guard let viewFromNib = loadViewFromNib() else {
            return
        }
        
        self.addSubview(viewFromNib)
        viewFromNib.frame = CGRect(origin: .zero, size: frame.size)
        
        amountButtons.forEach(makeButtonRound)
    }
    
    func makeButtonRound(_ button: UIButton) {
        button.setCornerRadius()
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
                if i == self?.selectedIndex {
                    buttons[i].backgroundColor = UIColor(named: "starbucks_green_light")
                    buttons[i].layer.borderColor = nil
                } else {
                    buttons[i].backgroundColor = UIColor.white
                    buttons[i].layer.borderColor = UIColor.darkGray.cgColor
                }
            }
        } completion: { [weak self] _ in
            self?.isUserInteractionEnabled = true
        }
    }
}
