import Foundation
import RxSwift

class InitialEventUseCase {
  
  private let initialURLSession = InitialURLSession()
  
  func getBackgroundImage() -> Observable<Data> {
    initialURLSession.image
  }
  
  func getInitialInfo() -> Observable<InitialDTO> {
    initialURLSession.info.compactMap { data in
      if let result = try? JSONDecoder().decode(InitialDTO.self, from: data) {
        return result
      }
      
      return nil
    }
  }
}
