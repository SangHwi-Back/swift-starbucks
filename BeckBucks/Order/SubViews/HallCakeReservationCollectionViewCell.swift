//
//  HallCakeReservationCollectionViewCell.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/13.
//

import UIKit

class HallCakeReservationCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var priceTagLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setUI() {
        imageView.setCornerRadius(40)
        titleLabel.mutateListTitleStyleLabel()
        subTitleLabel.mutateListSubTitleStyleLabel()
        priceTagLabel.mutatePriceTagStyleLabel()
    }
}
