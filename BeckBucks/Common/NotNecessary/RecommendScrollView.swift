//
//  RecommendScrollView.swift
//  BeckBucks
//
//  Created by 백상휘 on 2022/09/20.
//

import UIKit
import RxCocoa
import RxSwift

class RecommendScrollView: UIScrollView {
  
  static let padding: CGFloat = 20
  
  private var contentSizeWidthRelay = BehaviorRelay<CGPoint>(value: .zero)
  private var disposeBag = DisposeBag()
  var lastView: UIView? {
    subviews.filter({$0 is RecommendContentsView}).max(by: { $0.frame.maxX < $1.frame.maxX })
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    initialSetting()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    initialSetting()
  }
  
  private func initialSetting() {
    contentSizeWidthRelay
      .subscribe { [weak self] event in
        switch event {
        case .next(let point):
          guard let currentWidth = self?.contentSize.width, currentWidth < point.x else { return }
          self?.contentSize.width = point.x + RecommendScrollView.padding
        default:
          self?.contentSize.width = self?.frame.width ?? 0
        }
      }
      .disposed(by: disposeBag)
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
    
    customView?.frame.origin.x += ((lastView?.frame.maxX ?? 0) + RecommendScrollView.padding)
    (customView as? ViewImageTitled)?.imageView?.putShadows()
    contentSizeWidthRelay
      .accept(CGPoint(x: (customView?.frame.maxX ?? 0), y: 0))
    
    return customView as? RecommendContentsView
  }
  
  func dispose() {
    self.disposeBag = DisposeBag()
  }
}
