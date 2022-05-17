import Foundation
import RxSwift

protocol HTTPRequest {
  var httpMethod: HTTPMethods { get }
  func requestRESTAPI() -> Observable<Data>
}

enum HTTPMethods {
  case GET
  case POST
}

struct HTTPResult {
  let response: URLResponse?
  let data: Data?
  let message: String
}
