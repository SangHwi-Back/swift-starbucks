import Foundation

extension URLProtocol {
  static var protocolClass: URLSessionConfiguration {
    let conf = URLSessionConfiguration.default
    
    if conf.protocolClasses == nil {
      conf.protocolClasses = []
    }
    
    if conf.protocolClasses?.contains(where: { $0 == Self.self }) == false {
      conf.protocolClasses?.append(Self.self)
    }
    
    return conf
  }
}

class CommonBucksProtocol: URLProtocol {
  
  var resourceName: String = ""
  var resourceExtension: String = ""
  
  lazy var handler: ((URLRequest) throws -> (HTTPURLResponse, Data)) = { [weak self] request in
    
    var resultData: Data?
    
    
    if let url = Bundle.main.url(forResource: self?.resourceName, withExtension: self?.resourceExtension),
       let data = try? Data.init(contentsOf: url, options: Data.ReadingOptions.uncached) {
      resultData = data
    }
    
    guard let response = HTTPURLResponse(
      url: request.url!,
      statusCode: 200,
      httpVersion: nil,
      headerFields: nil)
    else {
        if let self = self {
            self.client?.urlProtocol(self, didFailWithError: ProtocolError.noResponse)
        }
      
      throw ProtocolError.noResponse
    }
    
    guard let data = resultData else {
        if let self = self {
            self.client?.urlProtocol(self, didFailWithError: ProtocolError.noResponse)
        }
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
