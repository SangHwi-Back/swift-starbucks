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
    
    deinit {
        URLProtocol.unregisterClass(HTTPRequestMockProtocol.self)
    }
    
    private let useCase = OrderAllMenuUseCase()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func initialBind() {
        URLProtocol.registerClass(HTTPRequestMockProtocol.self)
        
        let cellIdentifier = String(describing: OrderMenuListCollectionViewCell.self)
        
        allMenuListCollectionView.register(OrderMenuListCollectionViewCell.self,
                                           forCellWithReuseIdentifier: cellIdentifier)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        layout.minimumLineSpacing = 16
        layout.itemSize = CGSize(width: contentView.frame.size.width-32,
                                          height: 50)
        
        allMenuListCollectionView.collectionViewLayout = layout
        allMenuListCollectionView.dataSource = nil
        
        useCase.itemBinder
            .bind(to: allMenuListCollectionView.rx
                .items(cellIdentifier: cellIdentifier,
                       cellType: OrderMenuListCollectionViewCell.self)
            ) { [weak self] (row, _, cell) in
                
                cell.resetUIComponents()
                
                guard
                    let imageView = cell.menuImageView,
                    let disposeBag = self?.useCase.disposeBag
                else {
                    return
                }
                
                self?.useCase
                    .bindRequestedImage(rowNumber: row)
                    .bind(to: imageView.rx.image)
                    .disposed(by: disposeBag)
                
                cell.menuTitleLabel?.text = self?.useCase.getItemTitle(rowNumber: row)
            }
            .disposed(by: useCase.disposeBag)
        
        useCase.selectedMenuBinder
            .bind(onNext: { selectedButton in
                switch selectedButton {
                case .beverage:
                    self.headerBeverageMenuButton.titleLabel?.setBoldFont()
                    self.headerFoodMenuButton.titleLabel?.setNormalFont()
                case .food:
                    self.headerBeverageMenuButton.titleLabel?.setNormalFont()
                    self.headerFoodMenuButton.titleLabel?.setBoldFont()
                }
            })
            .disposed(by: useCase.disposeBag)
        
        headerBeverageMenuButton.rx
            .tap
            .bind(onNext: { _ in
                self.useCase.setSelectedMenuButton(.beverage)
            })
            .disposed(by: useCase.disposeBag)
        
        headerFoodMenuButton.rx
            .tap
            .bind(onNext: { _ in
                self.useCase.setSelectedMenuButton(.food)
            })
            .disposed(by: useCase.disposeBag)
    }
    
    func resolveUI() {
        headerBeverageMenuButton.sendActions(for: .touchUpInside)
    }
}

private extension UILabel {
    func getBoldFont() -> UIFont? {
        UIFont.systemFont(ofSize: self.font.pointSize, weight: .bold)
    }
    func setBoldFont() {
        self.font = UIFont.boldSystemFont(ofSize: self.font.pointSize)
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
