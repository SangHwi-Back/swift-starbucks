import Foundation
import RxSwift

enum ImageURLSessionError: Error {
  case methodNotFound
}

class ImageURLSession {
  func getStarbucksImage(_ request: URLRequest) -> Observable<Data> {
    switch request.httpMethod?.uppercased() {
    case "GET":
      return URLSession(configuration: ImageBucksGETProtocol.protocolClass).rx.data(request: request)
    case "POST":
      return URLSession(configuration: ImageBucksPOSTProtocol.protocolClass).rx.data(request: request)
    default:
      return Observable.create({
        let disposables = Disposables.create()
        $0.onError(ImageURLSessionError.methodNotFound)
        return disposables
      })
    }
  }
}
