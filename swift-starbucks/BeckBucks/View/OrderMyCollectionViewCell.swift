//
//  OrderMyMenuCollectionViewCell.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/04.
//

import UIKit

protocol OrderCollectionViewCell {
    func makeUI()
}

class OrderMyCollectionViewCell: UICollectionViewCell {
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
