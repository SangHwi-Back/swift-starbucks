//
//  OrderMenuListCollectionViewCell.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/11.
//

import UIKit

class OrderMenuListCollectionViewCell: UICollectionViewCell {
    
    var parent: OrderAllCollectionViewCell?
    var entity: StarbucksItemDTO?
    
    // MARK: - Insert view programmatically. CollectionViewDelegate cannot catch moment IBOutlets initialized.
    var menuImageView: UIImageView?
    var menuTitleLabel: UILabel?
    var menuLabelStackView: UIStackView?
    
    func resetUIComponents() {
        contentView
            .subviews.forEach { $0.removeFromSuperview() }
        
        let imageView = UIImageView()
        let titleLabel = UILabel()
        let stackView = UIStackView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .vertical
        stackView.spacing = 3
        stackView.distribution = .fillProportionally
        stackView.addArrangedSubview(titleLabel)
        
        titleLabel.font = titleLabel.font.withSize(12)
        titleLabel.minimumScaleFactor = 0.2
        titleLabel.numberOfLines = 2
        
        contentView.addSubview(imageView)
        contentView.addSubview(stackView)
        
        [
            imageView.leadingAnchor
                .constraint(equalTo: contentView.leadingAnchor, constant: 16),
            imageView.topAnchor
                .constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor
                .constraint(equalTo: contentView.bottomAnchor),
            imageView.widthAnchor
                .constraint(equalToConstant: 50),
            
            stackView.leadingAnchor
                .constraint(equalTo: imageView.trailingAnchor, constant: 8),
            stackView.trailingAnchor
                .constraint(equalTo: contentView.trailingAnchor, constant: 16),
            stackView.topAnchor
                .constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor
                .constraint(equalTo: contentView.bottomAnchor),
        ].forEach {
            $0.isActive = true
        }
        
        imageView.setCornerRadius(25)
        
        menuImageView = imageView
        menuTitleLabel = titleLabel
        menuLabelStackView = stackView
    }
}
