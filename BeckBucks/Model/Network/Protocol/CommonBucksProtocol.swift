import Foundation

class CommonBucksProtocol: URLProtocol {
  
  private(set) var resourceName: String = ""
  private(set) var resourceExtension: String = ""
  
  static var protocolClass: URLSessionConfiguration {
    let conf = URLSessionConfiguration.default
    conf.protocolClasses = [self]
    return conf
  }
  
  lazy var handler: ((URLRequest) throws -> (HTTPURLResponse, Data)) = { request in
    
    var resultData: Data?
    
    if let url = Bundle.main.url(forResource: self.resourceName, withExtension: self.resourceExtension),
       let data = try? Data(contentsOf: url) {
      resultData = data
    }
    
    guard let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil) else {
      self.client?.urlProtocol(self, didFailWithError: ProtocolError.noResponse)
      throw ProtocolError.noResponse
    }
    
    guard let data = resultData else {
      self.client?.urlProtocol(self, didFailWithError: ProtocolError.noData)
      throw ProtocolError.noData
    }
    
    return (response, data)
  }
  
  override class func canInit(with request: URLRequest) -> Bool {
    true
  }
  
  override class func canonicalRequest(for request: URLRequest) -> URLRequest {
    request
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
