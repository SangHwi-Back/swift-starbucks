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
        layout.sectionInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        layout.minimumLineSpacing = 8
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
    }
    
    func resolveUI(_ jsonTitle: String) {
        useCase.resolveUI(jsonTitle)
    }
}
