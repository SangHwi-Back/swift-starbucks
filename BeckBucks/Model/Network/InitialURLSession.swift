import Foundation
import RxSwift

class InitialURLSession {
  
  var imageURL: URL
  var infoURL: URL
  
  init() {
    imageURL = URL(string: "https://s3.ap-northeast-2.amazonaws.com")!
    imageURL.appendPathComponent("lucas-image.codesquad.kr")
    imageURL.appendPathComponent("1627033273796event-bg.png")
    
    infoURL = URL(string: "https://public.codesquad.kr")!
    infoURL.appendPathComponent("jk")
    infoURL.appendPathComponent("boostcamp")
    infoURL.appendPathComponent("starbuckst-loading.json")
  }
  
  var info: Observable<Data> {
    
    let configuration = URLSessionConfiguration.default
    configuration.protocolClasses = [InitialInfoBucksProtocol.self]
    
    return URLSession(configuration: configuration).rx
      .data(request: URLRequest(url: infoURL))
      .share(replay: 1)
  }
  
  var image: Observable<Data> {
    
    let configuration = URLSessionConfiguration.default
    configuration.protocolClasses = [InitialImageBucksProtocol.self]
    
    return URLSession(configuration: configuration).rx
      .data(request: URLRequest(url: imageURL))
      .share(replay: 1)
  }
}
