//
//  OrderMenuListCollectionViewCell.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/11.
//

import UIKit

class OrderMenuListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var menuImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var rowNumber: Int?
    var useCase: OrderAllMenuUseCase?
    
    func resetUIComponents() {
        
        guard let useCase, let rowNumber else { return }
        
        useCase
            .bindRequestedImage(rowNumber: rowNumber)
            .bind(to: menuImageView.rx.image)
            .disposed(by: useCase.disposeBag)
        
        menuImageView.setCornerRadius()
        
        titleLabel.text = useCase.getItemTitle(rowNumber: rowNumber)
    }
}
