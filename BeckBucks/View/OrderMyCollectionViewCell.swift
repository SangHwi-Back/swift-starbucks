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
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var myMenuListCollectionView: UICollectionView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
