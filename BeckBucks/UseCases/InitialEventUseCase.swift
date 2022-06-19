import Foundation
import RxCocoa

class InitialEventUseCase {
  
  private let initialURLSession = InitialURLSession()
  
  func getBackgroundImage() -> Driver<Data> {
    initialURLSession.image.asDriver(onErrorJustReturn: Data())
  }
  
  func getInitialInfo() -> Driver<InitialDTO?> {
    initialURLSession.info.map({ data in
      if let result = try? JSONDecoder().decode(InitialDTO.self, from: data) {
        return result
      }
      
      return nil
    })
    .asDriver(onErrorJustReturn: nil)
  }
}
