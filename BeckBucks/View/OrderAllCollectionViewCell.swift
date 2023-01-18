//
//  OrderAllMenuCollectionViewCell.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/04.
//

import UIKit
import RxSwift
import RxCocoa

class OrderAllCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var headerMenuView: UIView!
    @IBOutlet weak var allMenuListCollectionView: UICollectionView!
    
    @IBOutlet var headerBeverageMenuButton: UIButton!
    @IBOutlet var headerFoodMenuButton: UIButton!
    
    var useCase: OrderAllMenuUseCase?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func initialBind() {
        contentView.setNeedsLayout()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.itemSize = CGSize(width: contentView.frame.width-32, height: 50)
        
        allMenuListCollectionView.collectionViewLayout = layout
        allMenuListCollectionView.dataSource = nil
        
        guard let useCase else { return }
        
        useCase.itemBinder
            .bind(to: allMenuListCollectionView.rx
                .items(cellIdentifier: String(describing: OrderMenuListCollectionViewCell.self),
                       cellType: OrderMenuListCollectionViewCell.self)
            ) { [weak self] (row, _, cell) in
                
                cell.rowNumber = row
                cell.useCase = self?.useCase
                cell.resetUIComponents()
            }
            .disposed(by: useCase.disposeBag)
        
        useCase.selectedMenuBinder
            .map({ $0 == .beverage })
            .bind(onNext: { [
                weak headerBeverageMenuButton,
                weak headerFoodMenuButton
            ] isBeverage in
                
                let selectedFont = headerBeverageMenuButton?.titleLabel?.getBoldFont()
                let deSelectedFont = headerBeverageMenuButton?.titleLabel?.getNormalFont()
                
                headerBeverageMenuButton?.titleLabel?
                    .font = isBeverage ? selectedFont : deSelectedFont
                headerFoodMenuButton?.titleLabel?
                    .font = isBeverage ? deSelectedFont : selectedFont
            })
            .disposed(by: useCase.disposeBag)
        
        headerBeverageMenuButton.rx
            .tap
            .bind(onNext: { _ in
                useCase.setSelectedMenuButton(.beverage)
            })
            .disposed(by: useCase.disposeBag)
        
        headerFoodMenuButton.rx
            .tap
            .bind(onNext: { _ in
                useCase.setSelectedMenuButton(.food)
            })
            .disposed(by: useCase.disposeBag)
        
        headerBeverageMenuButton.sendActions(for: .touchUpInside)
    }
}

private extension UILabel {
    func getBoldFont() -> UIFont? {
        UIFont.systemFont(ofSize: self.font.pointSize, weight: .bold)
    }
    func setBoldFont() {
        self.font = self.getBoldFont()
        self.textColor = .black
    }
    
    func getNormalFont() -> UIFont? {
        UIFont.systemFont(ofSize: self.font.pointSize, weight: .regular)
    }
    func setNormalFont() {
        self.font = self.getNormalFont()
        self.textColor = .darkGray
    }
}
