import Foundation
import RxCocoa

class InitialEventUseCase {
  
  private let initialURLSession = InitialURLSession()
  
  func getBackgroundImage() -> Driver<Data> {
    defer {
      URLProtocol.unregisterClass(HTTPRequestMockProtocol.self)
    }
    
    URLProtocol.registerClass(HTTPRequestMockProtocol.self)
    
    guard let url = Bundle.main.url(forResource: "InitialBackgroundImage", withExtension: "jpg") else {
      return Driver.just(Data())
    }
    
    return URLSession.shared.rx.data(request: URLRequest(url: url))
      .asDriver(onErrorJustReturn: Data())
  }
  
  func getInitialInfo() -> Driver<InitialDTO?> {
    defer {
      URLProtocol.unregisterClass(HTTPRequestMockProtocol.self)
    }
    
    URLProtocol.registerClass(HTTPRequestMockProtocol.self)
    
    guard let fileURL = Bundle.main.url(forResource: "InitialJSON", withExtension: "json") else {
      return Driver.just(nil)
    }
    
    return URLSession.shared.rx.data(request: URLRequest(url: fileURL))
      .map { try? JSONDecoder().decode(InitialDTO.self, from: $0) }
      .asDriver(onErrorJustReturn: nil)
  }
}
