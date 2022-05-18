import Foundation
import RxSwift

class PayURLSession {

  // MARK: - URLs
  
  private var itemURL: URL
  
  init() {
    itemURL = URL(string: "https://www.starbucks.co.kr")!
    itemURL.appendPathComponent("menu")
    itemURL.appendPathComponent("productViewAjax.do")
  }
  
  // MARK: - Observables
  
  lazy var itemInfo: (String, Int?) -> Single<Data> = { productCd, index in
    var request = URLRequest.common(self.itemURL)
    request.httpMethod = "POST"
    request.httpBody = "product_cd=\(productCd)".data(using: .utf8)
    
    let conf = PayItemBucksProtocol.self
    
    if let index = index {
      conf.fileIndex = index
    }
    
    return URLSession(configuration: conf.protocolClass).rx
      .data(request: request)
      .share(replay: 1)
      .asSingle()
  }
  
  lazy var imageInfo: (String) -> Single<Data> = { productCd in
    var request = URLRequest.common(self.itemURL)
    request.httpMethod = "POST"
    request.httpBody = "PRODUCT_CD=\(productCd)".data(using: .utf8)
    
    return URLSession(configuration: PayImageBucksProtocol.protocolClass).rx
      .data(request: request)
      .share(replay: 1)
      .asSingle()
  }
}
