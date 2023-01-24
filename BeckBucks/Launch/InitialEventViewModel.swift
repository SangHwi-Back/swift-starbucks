import Foundation
import RxSwift

class InitialEventViewModel {
  
  private let initialURLSession = InitialURLSession()
  
  init() {
    URLProtocol.registerClass(HTTPRequestMockProtocol.self)
  }
  
  deinit {
    URLProtocol.unregisterClass(HTTPRequestMockProtocol.self)
  }
  
  func getBackgroundImage() -> Observable<Data> {
    guard let url = Bundle.main.url(forResource: "InitialBackgroundImage", withExtension: "jpg") else {
      return Observable.just(Data())
    }
    
    return URLSession.shared.rx.data(request: URLRequest(url: url))
  }
  
  func getInitialInfo() -> Observable<InitialDTO?> {
    guard let fileURL = Bundle.main.url(forResource: "InitialJSON", withExtension: "json") else {
      return Observable.just(nil)
    }
    
    return URLSession.shared.rx.data(request: URLRequest(url: fileURL))
      .map { try? JSONDecoder().decode(InitialDTO.self, from: $0) }
  }
}
