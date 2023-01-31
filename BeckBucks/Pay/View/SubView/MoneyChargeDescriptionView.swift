//
//  MoneyChargeDescriptionView.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/31.
//

import UIKit
import RxCocoa
import RxSwift

class MoneyChargeDescriptionView: UIView {
    
    @IBOutlet weak var showDescriptionButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    private var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        guard let viewFromNib = loadViewFromNib() else {
            return
        }
        
        self.addSubview(viewFromNib)
        viewFromNib.frame = CGRect(origin: .zero, size: frame.size)
        
        showDescriptionButton.rx.tap
            .observeOn(MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let label = self?.descriptionLabel else { return }
                label.isHidden = !label.isHidden
            })
            .disposed(by: disposeBag)
    }
}
