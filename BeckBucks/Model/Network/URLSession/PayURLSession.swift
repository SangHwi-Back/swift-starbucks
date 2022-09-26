import Foundation
import RxSwift

class PayURLSession {

  // MARK: - URLs
  
  init() {
  }
  
  // MARK: - Observables
  
  lazy var itemInfo: (String, Int?) -> Single<Data> = { productCd, index in
    defer {
      URLProtocol.unregisterClass(HTTPRequestMockProtocol.self)
    }
    
    URLProtocol.registerClass(HTTPRequestMockProtocol.self)
    
    if let url = Bundle.main.url(forResource: productCd, withExtension: "jpg") {
      return URLSession.shared.rx.data(request: URLRequest(url: url))
        .share(replay: 1)
        .asSingle()
    }
    
    return Single<Data>.just(Data())
  }
  
  lazy var postImageInfo: (String) -> Single<Data> = { productCd in
    defer {
      URLProtocol.unregisterClass(HTTPRequestMockProtocol.self)
    }
    
    URLProtocol.registerClass(HTTPRequestMockProtocol.self)
    
    guard let url = Bundle.main.url(forResource: productCd, withExtension: "jpg") else {
      return Single.just(Data())
    }
    
    return URLSession.shared.rx.data(request: URLRequest(url: url))
      .share(replay: 1)
      .asSingle()
  }
  
  lazy var getImageInfo: (String) -> Single<Data> = { resourceName in
    defer {
      URLProtocol.unregisterClass(HTTPRequestMockProtocol.self)
    }
    
    URLProtocol.registerClass(HTTPRequestMockProtocol.self)
    
    guard let url = Bundle.main.url(forResource: resourceName, withExtension: "jpg") else {
      return Single.just(Data())
    }
    
    return URLSession.shared.rx.data(request: URLRequest.common(url))
      .share(replay: 1)
      .asSingle()
  }
}
