//
//  MyBagCollectionViewEmptyCell.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/15.
//

import UIKit

class MyBagCollectionViewEmptyCell: UICollectionViewCellHeightAdjusted {
    
    @IBOutlet weak var backgroundScrollView: UIScrollView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var orderViewButton: UIButton!
    @IBOutlet weak var symbolImageView: UIImageView!
    @IBOutlet weak var paddingView: UIView!
    
    func resolveUI() {
        
    }
}
