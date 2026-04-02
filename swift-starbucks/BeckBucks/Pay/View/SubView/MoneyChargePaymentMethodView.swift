//
//  MoneyChargePaymentMethodView.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/31.
//

import UIKit
import RxSwift
import RxCocoa

class MoneyChargePaymentMethodView: UIView {
    
    enum SelectedMethod {
        case creditCard
        case ssgPay
    }
    
    var chargeMethodSubject = PublishSubject<SelectedMethod>()
    private(set) var selectedMethod = SelectedMethod.creditCard {
        didSet {
            chargeMethodSubject.onNext(selectedMethod)
        }
    }
    
    private var disposeBag = DisposeBag()
    
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
        
        Observable<UIButton>
            .merge([
                setCreditCardButton.rx.tap
                    .map({self.setCreditCardButton})
                    .do(onNext: { [weak self] _ in
                        self?.selectedMethod = .creditCard
                    }),
                setSSGPAYButton.rx.tap
                    .map({self.setSSGPAYButton})
                    .do(onNext: { [weak self] _ in
                        self?.selectedMethod = .ssgPay
                    })
            ])
            .bind(onNext: { [weak setCreditCardButton, weak setSSGPAYButton] button in
                
                [setCreditCardButton, setSSGPAYButton].forEach {
                    let imageName = button == $0 ? "circle.circle.fill" : "circle"
                    $0?.setImage(UIImage(systemName: imageName), for: .normal)
                }
            })
            .disposed(by: disposeBag)
    }
}
