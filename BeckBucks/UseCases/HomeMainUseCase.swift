import RxSwift
import RxCocoa
import Foundation

enum UseCaseError: Error {
  case testError
}

class HomeMainUseCase {
  
  
  private let model = HTTPRequestMockModel()
  private let decoder = JSONDecoder()
  
  func getMainInfo() -> Single<Data> {
    model.getImage(from: Bundle.main.url(forResource: "jpg", withExtension: "homeMainImage"))
  }
  
  func getThumbDataImage() -> Single<Data> {
    model.getImage(from: Bundle.main.url(forResource: "jpg", withExtension: "homeMainThumbImage"))
  }
  
  func getIngList() -> ReplaySubject<Data?> {
    guard let urls = Bundle.main.urls(forResourcesWithExtension: "jpg", subdirectory: "ingevent") else {
      return ReplaySubject<Data?>
        .create(bufferSize: 1)
    }
    
    let result = ReplaySubject<Data?>.create(bufferSize: urls.count)
    
    for url in urls {
      model.getImage(from: url)
        .subscribe { event in
          switch event {
          case .error(_):
            result.onNext(nil)
          case .success(let data):
            result.onNext(data)
          }
        }
        .dispose()
    }
    
    return result
  }
  
  func dispose() { }
}
