//
//  ResizableImageView.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/27.
//

import UIKit

/// Thanks to : https://stackoverflow.com/a/48937190
class ResizableImageView: UIImageView {
    
    func resize(pinWidth width: CGFloat) {
        self.frame.size.width = width
        self.frame.size = intrinsicContentSize
    }
    
    override var intrinsicContentSize: CGSize {
        
        if let myImage = self.image {
            let myImageWidth = myImage.size.width
            let myImageHeight = myImage.size.height
            let myViewWidth = self.frame.size.width
            
            let ratio = myViewWidth/myImageWidth
            let scaledHeight = myImageHeight * ratio
            
            return CGSize(width: myViewWidth, height: scaledHeight)
        }
        
        return CGSize(width: -1.0, height: -1.0)
    }
}
