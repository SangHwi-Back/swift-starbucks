//
//  MyBagCollectionViewEmptyCell.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/15.
//

import UIKit

class MyBagCollectionViewEmptyCell: UICollectionViewCell {
    
    @IBOutlet weak var backgroundScrollView: UIScrollView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var orderViewButton: UIButton!
    @IBOutlet weak var symbolImageView: UIImageView!
    @IBOutlet weak var paddingView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func resolveUI() {
        
    }
}
