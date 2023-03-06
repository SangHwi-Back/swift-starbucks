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
    @IBOutlet weak var superStackView: UIStackView!
    
    private var selectableButtons: [UIButton] = []
    private var selectedIndex = 0
    private var buttonDisposeBag = DisposeBag()
    private var disposeBag = DisposeBag()
    
    var chargeAmountSubject = PublishSubject<Float>()
    let currencyInfoBehaviorSubject = BehaviorSubject<([String], String)>(value: ([], ""))
    private var definedButton: UIButton?
    
    var moneyModel: MoneyFromCurrencyModel?
    
    private var lastStackView: UIStackView? {
        superStackView.arrangedSubviews.last as? UIStackView
    }
    
    private var spacer: () -> UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(greaterThanOrEqualToConstant: 1).isActive = true
        return view
    }
    
    private func iterateSuperStackView(_ handler: @escaping (UIStackView) -> Void) {
        superStackView
            .arrangedSubviews
            .compactMap({$0 as? UIStackView})
            .forEach { stackView in
                handler(stackView)
            }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let viewFromNib = loadAllViewFromNib()
        
        guard
            let targetView = viewFromNib.first,
            let button = viewFromNib.last as? UIButton
        else {
            return
        }
        
        self.addSubview(targetView)
        self.definedButton = button
        targetView.frame = CGRect(origin: .zero, size: frame.size)
    }
    
    func makeButtons() {
        guard let moneyModel else { return }
        
        iterateSuperStackView({ stackView in
            stackView.subviews.forEach { view in
                stackView.removeArrangedSubview(view)
            }
        })
        
        selectableButtons.removeAll()
        
        moneyModel.getJSONFetchObservable()
            .observeOn(MainScheduler.instance)
            .do(
                onNext: { [weak self] result in
                    let result = try? JSONDecoder().decode(ExchangeRateWrapper.self, from: result.data)
                    self?.moneyModel?.rates = result?.rates ?? []
                },
                afterNext: { [weak self] _ in
                    var buttons: [UIButton] = []
                    self?.iterateSuperStackView({ stackView in
                        let contents = stackView.arrangedSubviews.compactMap({$0 as? UIButton})
                        buttons.append(contentsOf: contents)
                    })
                    
                    self?.bindButtons(buttons)
                }
            )
            .bind { [weak self] _ in
                guard
                    let amounts = self?.moneyModel?.getDefinedChargeStrings(),
                    let symbol = self?.moneyModel?.getCurrencySymbol()
                else {
                    return
                }
                
                for amount in amounts {
                    guard
                        let buttonCount = self?.lastStackView?.arrangedSubviews.count,
                        let button = self?.definedButton?.copyView() as? UIButton
                    else {
                        continue
                    }
                    
                    if buttonCount >= 3 {
                        self?.addStackViewForButtons()
                    }
                    
                    self?.lastStackView?.addArrangedSubview(button)
                    self?.makeButtonRound(button)
                    button.setTitle("\(amount) \(symbol)", for: .normal)
                    self?.selectableButtons.append(button)
                }
                
                self?.lastStackView?.addArrangedSubview(UIView())
            }
            .disposed(by: disposeBag)
    }
    
    private func bindButtons(_ buttons: [UIButton]) {
        buttonDisposeBag = DisposeBag()
        
        Observable<Int>
            .merge(
                buttons.enumerated().map({ index, subButton in
                    subButton.rx.tap.map({index})
                })
            )
            .bind(onNext: { [weak self] num in
                guard
                    let balances = self?.moneyModel?.getDefinedChargeAmounts(),
                    num < balances.count
                else {
                    return
                }
                
                self?.selectedIndex = num
                self?.changeButtonSelected(at: num)
                self?.chargeAmountSubject.onNext(Float(balances[num]))
            })
            .disposed(by: buttonDisposeBag)
    }
    
    private func addStackViewForButtons() {
        
        lastStackView?.addArrangedSubview(UIView())
        guard let copiedStackView = lastStackView?.copyView() as? UIStackView else {
            return
        }
        
        copiedStackView.arrangedSubviews.forEach({ view in
            copiedStackView.removeArrangedSubview(view)
        })
        superStackView.addArrangedSubview(copiedStackView)
    }
    
    private func makeButtonRound(_ button: UIButton) {
        button.setCornerRadius(4)
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.layer.borderWidth = 1
    }
    
    private func changeButtonSelected(at index: Int) {
        guard index < selectableButtons.count else { return }

        self.selectedIndex = index
        self.isUserInteractionEnabled = false

        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let buttons = self?.selectableButtons else { return }
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
