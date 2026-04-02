//
//  UICollectionViewCellHeightAdjusted.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/02/06.
//

import UIKit

/// Thanks to https://stackoverflow.com/a/25896386
class UICollectionViewCellHeightAdjusted: UICollectionViewCell {
    var isHeightCalculated: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        if isHeightCalculated == false {
            
            setNeedsLayout()
            
            let size = contentView.systemLayoutSizeFitting(layoutAttributes.size,
                                                           withHorizontalFittingPriority: .defaultHigh,
                                                           verticalFittingPriority: .defaultLow)
            
            layoutAttributes.frame = CGRect(origin: .zero, size: size)
            
            isHeightCalculated = true
        }
        
        return layoutAttributes
    }
}
