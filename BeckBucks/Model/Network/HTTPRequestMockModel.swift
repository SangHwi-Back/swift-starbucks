//
//  HTTPRequestMockModel.swift
//  BeckBucks
//
//  Created by 백상휘 on 2022/09/25.
//

import Foundation
import RxSwift
import RxCocoa

class HTTPRequestMockModel {
  
  func getImage(from url: URL?) -> Single<Data> {
    guard let url = url else {
      return Single.just(Data())
    }
    
    return URLSession.shared.rx.data(request: URLRequest(url: url))
      .share()
      .asSingle()
  }
}
