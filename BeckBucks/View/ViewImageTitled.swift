//
//  ViewImageTitled.swift
//  BeckBucks
//
//  Created by 백상휘 on 2022/09/20.
//

import UIKit
import RxSwift
import RxCocoa

class ViewImageTitled: UIView, RecommendContentsView {
  var lastView: UIView?
  var imageView: UIImageView?
  var titleLabel: UILabel?
  var disposeBag = DisposeBag()
  
  var constantWidth: CGFloat = 160
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    makeUI()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    makeUI()
  }
  
  func makeUI() {
    let width = frame == .zero ? 0 : frame.size.width
    let createdImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: width))
    imageView = createdImageView
    addSubview(createdImageView)
    
    if constantWidth < frame.size.height {
      let createdLabel = UILabel(frame: CGRect(x: 0, y: width, width: width, height: RecommendScrollView.padding))
      createdLabel.textColor = .label
      addSubview(createdLabel)
      titleLabel = createdLabel
      lastView = titleLabel
      titleLabel?.adjustsFontSizeToFitWidth = true
    }
  }
  
  func setImage(from url: URL) {
    getImage(from: URLRequest(url: url))
  }
  
  func setImage(from urlString: String) {
    guard let url = URL(string: urlString) else { return }
    getImage(from: URLRequest(url: url))
  }
  
  private func getImage(from request: URLRequest) {
    guard let imageView = imageView else { return }
    
    URLSession.shared.rx.data(request: request)
      .map ({ UIImage(data: $0) })
      .do(onCompleted: { [weak self] in
        self?.disposeBag = DisposeBag()
      })
      .bind(to: imageView.rx.image)
      .disposed(by: disposeBag)
  }
}
