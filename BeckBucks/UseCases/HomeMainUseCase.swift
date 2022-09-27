import RxSwift
import RxCocoa
import Foundation

enum UseCaseError: Error {
  case testError
}

class HomeMainUseCase {
  
  init() {
    URLProtocol.registerClass(HTTPRequestMockProtocol.self)
  }
  
  deinit {
    URLProtocol.unregisterClass(HTTPRequestMockProtocol.self)
  }
  
  private let model = HTTPRequestMockModel()
  private let decoder = JSONDecoder()
  private var disposeBag = DisposeBag()
  
  func getRecommendationsForUser() -> Observable<(StarbucksItemDTO, Data)> {
    guard let jsonURL = Bundle.main.url(forResource: "recommendation", withExtension: "json") else {
      return Observable.empty()
    }
    
    let jsonObservable = URLSession.shared.rx
      .data(request: URLRequest(url: jsonURL))
      .compactMap({
        data in try? JSONDecoder().decode(StarbucksArray.self, from: data)
      })
      .flatMap({
        Observable<StarbucksItemDTO>.from($0.foods)
      })
    
    var urls = [URL]()
    for i in 1...4 {
      if let url = Bundle.main.url(forResource: "recommendation\(i)", withExtension: "jpg") {
        urls.append(url)
      }
    }
    
    let imageObservable: Observable<Data> = Observable<URL>
      .from(urls)
      .flatMap { url in
        URLSession.shared.rx.data(request: URLRequest(url: url))
      }
    
    return Observable<(StarbucksItemDTO, Data)>
      .zip(jsonObservable, imageObservable) {
        ($0, $1)
      }
  }
  
  func getMainInfo() -> Single<Data> {
    model.getImage(from: Bundle.main.url(forResource: "homeMainImage", withExtension: "jpg"))
  }
  
  func getThumbDataImage() -> Single<Data> {
    model.getImage(from: Bundle.main.url(forResource: "homeMainThumbImage", withExtension: "jpg"))
  }
  
  func getIngList() -> Observable<Data> {
    
    var urls = [URL]()
    for i in 1...8 {
      if let url = Bundle.main.url(forResource: "ingimg\(i)", withExtension: "jpg") {
        urls.append(url)
      }
    }
    
    guard urls.isEmpty == false else { return Observable.empty() }
    
    return Observable<URL>
      .from(urls)
      .flatMap { url in
        URLSession.shared.rx.data(request: URLRequest(url: url))
      }
  }
  
  func dispose() { }
}
