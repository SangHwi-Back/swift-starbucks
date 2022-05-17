import Foundation
import UIKit

class InitialImageBucksProtocol: URLProtocol {
  
  lazy var handler: ((URLRequest) throws -> (HTTPURLResponse, Data)) = { request in
    
    var resultData: Data?
    
    if let url = Bundle.main.url(forResource: "InitialBackgroundImage", withExtension: "png"),
       let data = try? Data(contentsOf: url) {
      resultData = data
    }
    
    guard let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil) else {
      self.client?.urlProtocol(self, didFailWithError: InitialError.noResponse)
      throw InitialError.noResponse
    }
    
    guard let data = resultData else {
      self.client?.urlProtocol(self, didFailWithError: InitialError.noData)
      throw InitialError.noData
    }
    
    return (response, data)
  }
  
  override class func canInit(with request: URLRequest) -> Bool {
    return true
  }
  
  override class func canonicalRequest(for request: URLRequest) -> URLRequest {
    return request
  }
  
  override func stopLoading() { }
  
  override func startLoading() {
      do {
        let (response, data) = try self.handler(self.request)
        self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .allowed)
        self.client?.urlProtocol(self, didLoad: data)
        self.client?.urlProtocolDidFinishLoading(self)
      } catch {
        self.client?.urlProtocol(self, didFailWithError: error)
      }
  }
}
