import Foundation
import RxSwift

class InitialURLSession {
  
  // MARK: - URLs
  
  private var imageURL: URL
  private var infoURL: URL
  
  init() {
    imageURL = URL(string: "https://s3.ap-northeast-2.amazonaws.com")!
    imageURL.appendPathComponent("lucas-image.codesquad.kr")
    imageURL.appendPathComponent("1627033273796event-bg.png")
    
    infoURL = URL(string: "https://public.codesquad.kr")!
    infoURL.appendPathComponent("jk")
    infoURL.appendPathComponent("boostcamp")
    infoURL.appendPathComponent("starbuckst-loading.json")
  }
  
  // MARK: - Observables
  
  var info: Observable<Data> {
    return URLSession(configuration: InitialInfoBucksProtocol.protocolClass).rx
      .data(request: URLRequest.common(infoURL))
      .share(replay: 1)
  }
  
  var image: Observable<Data> {
    return URLSession(configuration: InitialImageBucksProtocol.protocolClass).rx
      .data(request: URLRequest.common(imageURL))
      .share(replay: 1)
  }
}
