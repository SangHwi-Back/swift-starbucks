import Foundation
import RxSwift

class ImageURLSession {
  func getStarbucksImage(_ request: URLRequest) -> Observable<Data> {
    var session: Reactive<URLSession>
    
    switch request.httpMethod?.uppercased() {
    case "GET":
      session = URLSession(configuration: ImageBucksGETProtocol.protocolClass).rx
    case "POST":
      session = URLSession(configuration: ImageBucksPOSTProtocol.protocolClass).rx
    default:
      return Observable.empty()
    }
    
    return session.data(request: request).share(replay: 1)
  }
}
