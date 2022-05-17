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
    
    var session = URLSession.shared.rx
    
    if UserDefaults.standard.bool(forKey: "isUnitTest") {
      let conf = URLSessionConfiguration.default
      conf.protocolClasses = [InitialInfoBucksProtocol.self]
      session = URLSession(configuration: conf).rx
    }
    
    return session.data(request: URLRequest(url: infoURL)).share(replay: 1)
  }
  
  var image: Observable<Data> {
    
    var session = URLSession.shared.rx
    
    if UserDefaults.standard.bool(forKey: "isUnitTest") {
      let conf = URLSessionConfiguration.default
      conf.protocolClasses = [InitialImageBucksProtocol.self]
      session = URLSession(configuration: conf).rx
    }
    
    return session.data(request: URLRequest(url: imageURL)).share(replay: 1)
  }
}
