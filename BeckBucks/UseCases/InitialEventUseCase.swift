import Foundation
import RxCocoa

class InitialEventUseCase {
  
  private let initialURLSession = InitialURLSession()
  
  init() {
    URLProtocol.registerClass(HTTPRequestMockProtocol.self)
  }
  
  deinit {
    URLProtocol.unregisterClass(HTTPRequestMockProtocol.self)
  }
  
  func getBackgroundImage() -> Driver<Data> {
    guard let url = Bundle.main.url(forResource: "InitialBackgroundImage", withExtension: "jpg") else {
      return Driver.just(Data())
    }
    
    return URLSession.shared.rx.data(request: URLRequest(url: url))
      .asDriver(onErrorJustReturn: Data())
  }
  
  func getInitialInfo() -> Driver<InitialDTO?> {
    guard let fileURL = Bundle.main.url(forResource: "InitialJSON", withExtension: "json") else {
      return Driver.just(nil)
    }
    
    return URLSession.shared.rx.data(request: URLRequest(url: fileURL))
      .map { try? JSONDecoder().decode(InitialDTO.self, from: $0) }
      .asDriver(onErrorJustReturn: nil)
  }
}
