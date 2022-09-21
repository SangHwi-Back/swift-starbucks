//
//  RecommendScrollView.swift
//  BeckBucks
//
//  Created by 백상휘 on 2022/09/20.
//

import UIKit
import RxCocoa

class RecommendScrollView: UIScrollView {
  
  static let padding: CGFloat = 20
  var lastView: UIView? {
    subviews.filter({$0 is RecommendContentsView}).max(by: { $0.frame.maxX < $1.frame.maxX })
  }
  
  func insertView(_ view: UIView.Type) -> RecommendContentsView? {
    
    let height = frame.size.height
    var customView: UIView?
    let lastView = self.lastView
    
    if view.self == ViewImageTitled.self {
      
      let view = ViewImageTitled(frame: CGRect(origin: .zero, size: CGSize(width: height - RecommendScrollView.padding, height: height)))
      customView = view
      addSubview(view)
    } else if view.self == ViewImageSubTitled.self {
      
      let view = ViewImageSubTitled(frame: CGRect(origin: .zero, size: CGSize(width: height - (RecommendScrollView.padding * 2), height: height)))
      customView = view
      addSubview(view)
    }
    
    customView?.frame.origin.x = RecommendScrollView.padding
    if let lastView = lastView {
      customView?.frame.origin.x += lastView.frame.maxX
    }
    
    return customView as? RecommendContentsView
  }
  
  func reloadContentSizeWidth() {
    contentSize.width = RecommendScrollView.padding
    contentSize.width += lastView?.frame.maxX ?? 0
    contentSize.width += RecommendScrollView.padding
  }
}
