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
    let currencyInfoBehaviorSubject = BehaviorSubject<([Int], String)>(value: ([], ""))
    var definedButton: UIButton?
    
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
        
        iterateSuperStackView { stackView in
            let buttons = stackView.arrangedSubviews.compactMap({ $0 as? UIButton })
            buttons.forEach(self.makeButtonRound(_:))
        }
        
        currencyInfoBehaviorSubject
            .observeOn(MainScheduler.instance)
            .do(
                onNext: { [weak self] _, _ in
                    self?.iterateSuperStackView({ stackView in
                        stackView.subviews.forEach { view in
                            stackView.removeArrangedSubview(view)
                        }
                    })
                    
                    self?.selectableButtons.removeAll()
                },
                afterNext: { [weak self] _, _ in
                    var buttons: [UIButton] = []
                    self?.iterateSuperStackView({ stackView in
                        let contents = stackView.arrangedSubviews.compactMap({$0 as? UIButton})
                        buttons.append(contentsOf: contents)
                    })
                    
                    self?.bindButtons(buttons)
                }
            )
            .bind { [weak self] (amounts, symbol) in
                var lastStackView: UIStackView? {
                    self?.superStackView.arrangedSubviews.last as? UIStackView
                }
                
                for amount in amounts {
                    guard
                        let button = self?.definedButton?.copyView() as? UIButton,
                        var stackView = lastStackView
                    else {
                        continue
                    }
                    
                    if
                        stackView.arrangedSubviews.count >= 3,
                        let copiedStackView = stackView.copyView() as? UIStackView
                    {
                        stackView.addArrangedSubview(UIView())
                        
                        copiedStackView.arrangedSubviews.forEach({ view in
                            copiedStackView.removeArrangedSubview(view)
                        })
                        self?.superStackView.addArrangedSubview(copiedStackView)
                        stackView = copiedStackView
                    }
                    
                    stackView.addArrangedSubview(button)
                    self?.makeButtonRound(button)
                    button.setTitle("\(amount)\(symbol)", for: .normal)
                    self?.selectableButtons.append(button)
                }
                
                lastStackView?.addArrangedSubview(UIView())
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
                    let balances = try? self?.currencyInfoBehaviorSubject.value().0,
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
