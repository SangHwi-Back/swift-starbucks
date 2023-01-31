//
//  MoneyChargeViewController.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/31.
//

import UIKit
import RxSwift
import RxCocoa

class MoneyChargeViewController: UIViewController {
    
    @IBOutlet weak var cardInfoView: MoneyChargeCardInfoVIew!
    @IBOutlet weak var definedChargeAmountView: MoneyChargeDefinedChargeAmountView!
    @IBOutlet weak var paymentMethodView: MoneyChargePaymentMethodView!
    @IBOutlet weak var customButtonView: MoneyChargeCustomButtonView!
    @IBOutlet weak var descriptionView: MoneyChargeDescriptionView!
    
    
    let imageModel = MoneyChargeImageFetcher()
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        imageModel.getImageFrom(fileName: "pay_event")
            .map({UIImage(data: $0)})
            .bind(to: customButtonView.customButton.rx.backgroundImage())
            .disposed(by: disposeBag)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
}

class MoneyChargeImageFetcher: ImageFetchable {
    var imageData: [String : Data] = [:]
}
