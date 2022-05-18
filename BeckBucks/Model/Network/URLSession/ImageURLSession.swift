import Foundation
import RxSwift

class ImageURLSession {
  func getStarbucksImage(_ url: URL) -> Observable<Data> {
    return URLSession(configuration: ImageBucksProtocol.protocolClass).rx
      .data(request: URLRequest.common(url))
      .share(replay: 1)
  }
}
