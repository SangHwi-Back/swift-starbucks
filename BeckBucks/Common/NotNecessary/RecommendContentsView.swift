//
//  RecommendContentsView.swift
//  BeckBucks
//
//  Created by 백상휘 on 2022/09/20.
//

import UIKit

protocol RecommendContentsView {
  var imageView: UIImageView? { get set }
  var lastView: UIView? { get }
}

extension RecommendContentsView {
  var frame: CGRect {
    guard let imageView = imageView else {
      return .zero
    }
    
    var result = imageView.frame
    
    guard let lastView = lastView else {
      return result
    }
    
    let height = lastView.frame.maxY - result.size.height
    
    if height > 0 {
      result.size.height += height
    }
    
    return result
  }
}
