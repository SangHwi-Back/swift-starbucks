//
//  ViewImageSubTitled.swift
//  BeckBucks
//
//  Created by 백상휘 on 2022/09/20.
//

import UIKit

class ViewImageSubTitled: ViewImageTitled {
  var subTitleLabel: UILabel?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override func makeUI() {
    
    let width = frame == .zero ? 0 : frame.size.width
    let createdImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: width))
    imageView = createdImageView
    addSubview(createdImageView)
    
    if width < frame.size.height {
      
      let createdTitleLabel = UILabel(frame: CGRect(x: 0, y: width, width: width, height: RecommendScrollView.padding))
      titleLabel = createdTitleLabel
      addSubview(createdTitleLabel)
      titleLabel?.adjustsFontSizeToFitWidth = true
      
      let createdSubTitleLabel = UILabel(frame: CGRect(x: 0, y: width + (RecommendScrollView.padding * 2), width: width, height: RecommendScrollView.padding))
      subTitleLabel = createdSubTitleLabel
      addSubview(createdSubTitleLabel)
      subTitleLabel?.adjustsFontSizeToFitWidth = true
    }
  }
}
