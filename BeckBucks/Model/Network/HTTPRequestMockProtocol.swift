//
//  HTTPRequestMockProtocol.swift
//  BeckBucks
//
//  Created by 백상휘 on 2022/09/25.
//

import Foundation
import RxSwift
import RxCocoa

class HTTPRequestMockProtocol: URLProtocol {
  
  override class func canInit(with request: URLRequest) -> Bool {
    true
  }
  
  override class func canonicalRequest(for request: URLRequest) -> URLRequest {
    request
  }
  
  override func stopLoading() {}
  
  override func startLoading() {
    Single<(HTTPURLResponse?, Data?)>.create { single in
      let disposables = Disposables.create()
      
      guard let url = self.request.url else {
        single(.error(ProtocolError.urlError))
        return disposables
      }
      
      let result = try? Data(contentsOf: url, options: Data.ReadingOptions.uncached)
      
      guard let result = result else {
        single(.error(ProtocolError.noData))
        return disposables
      }
      
      single(.success(
        (HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil), result)
      ))
      
      return disposables
    }
    .subscribe { event in
      switch event {
      case .error(let error):
        self.client?.urlProtocol(self, didFailWithError: error)
      case .success(let mockResponse):
        if let response = mockResponse.0, let result = mockResponse.1 {
          self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .allowed)
          self.client?.urlProtocol(self, didLoad: result)
          self.client?.urlProtocolDidFinishLoading(self)
        } else {
          self.client?.urlProtocol(self, didFailWithError: ProtocolError.handlerError)
        }
      }
    }
    .dispose()
  }
}
