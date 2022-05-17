import Foundation
import RxSwift

class InitialEventUseCase {
  
  let initialURLSession = InitialURLSession()
  let bag = DisposeBag()
  
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
