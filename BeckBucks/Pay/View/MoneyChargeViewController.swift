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
    @IBOutlet weak var cardInfoFunctionalView: MoneyChargeCardInfoFunctionalView!
    @IBOutlet weak var definedChargeAmountView: MoneyChargeDefinedChargeAmountView!
    @IBOutlet weak var paymentMethodView: MoneyChargePaymentMethodView!
    @IBOutlet weak var customButtonView: MoneyChargeCustomButtonView!
    @IBOutlet weak var descriptionView: MoneyChargeDescriptionView!
    @IBOutlet weak var automationInfoView: MoneyChargeAutomaticInfoView!
    
    let imageModel = MoneyChargeImageFetcher()
    private var disposeBag = DisposeBag()
    var isAuto: Bool = false
    
    var updateEntitySubject: PublishSubject<CardInformation>?
    var entity: CardInformation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.setAutoView()
        
        imageModel.getImageFrom(fileName: "pay_event")
            .map({UIImage(data: $0)})
            .bind(to: customButtonView.customButton.rx.backgroundImage())
            .disposed(by: disposeBag)
        
        if let entity {
            cardInfoView.setCardInformation(entity)
            cardInfoFunctionalView.setCardInformation(entity)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let entity {
            var entity = entity
            entity.balance += 10000
            updateEntitySubject?.onNext(entity)
        }
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func setAutoView() {
        
        title = isAuto ? "자동 충전" : "일반 충전"
        
        if isAuto {
            
            cardInfoView.isHidden = true
            definedChargeAmountView.isHidden = true
            paymentMethodView.isHidden = true
            customButtonView.isHidden = true
            
            descriptionView.titleView.isHidden = true
            descriptionView.descriptionLabel.isHidden = false
            descriptionView.showDescriptionButton.isUserInteractionEnabled = false
            
            if let descView = descriptionView.subviews.first {
                descView.frame = descView.frame.insetBy(dx: 16, dy: 0)
            }
            
        } else {
            
            cardInfoFunctionalView.isHidden = true
            automationInfoView.isHidden = true
        }
    }
}

class MoneyChargeImageFetcher: ImageFetchable {
    var imageData: [String : Data] = [:]
}
