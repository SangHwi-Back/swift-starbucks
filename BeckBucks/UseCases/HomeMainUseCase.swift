import RxSwift
import Foundation

class HomeMainUseCase {
  
  private let homeURLSession = HomeURLSession()
  private let decoder = JSONDecoder()
  
  func getMainInfo() -> Observable<HomeMainDTO> {
    return homeURLSession.main.compactMap { [weak self] data in
      try? self?.decoder.decode(HomeMainDTO.self, from: data)
    }
  }
  
  func getThumbDataImage() -> Observable<Data> {
    return homeURLSession.thumb
  }
  
  func getIngList() -> Observable<HomeIngDTO> {
    return homeURLSession.main.compactMap { [weak self] data in
      try? self?.decoder.decode(HomeIngDTO.self, from: data)
    }
  }
}
