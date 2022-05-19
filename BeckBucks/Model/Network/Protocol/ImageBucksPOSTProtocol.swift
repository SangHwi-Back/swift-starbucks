import Foundation

class ImageBucksPOSTProtocol: URLProtocol {
  
  static var protocolClass: URLSessionConfiguration {
    let conf = URLSessionConfiguration.default
    conf.protocolClasses = [self]
    return conf
  }
  
  lazy var handler: ((URLRequest) throws -> (HTTPURLResponse, Data)) = { request in
    
    var resultData: Data?
    let requestBody = request.httpBody

    guard let bodyData = requestBody,
          let bodyString = String(data: bodyData, encoding: .utf8) else {
      self.client?.urlProtocol(self, didFailWithError: ProtocolError.bodyError)
      throw ProtocolError.bodyError
    }
    
    let bodies = bodyString.split(separator: "&")

    if let firstBody = bodies.first,
       let name = bodies.first?.split(separator: "=").first,
       let url = Bundle.main.url(forResource: String(name), withExtension: "jpg"),
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
    let randomSecond = Int.random(in: 0...3)
    
    DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + .seconds(randomSecond)) {
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
}
