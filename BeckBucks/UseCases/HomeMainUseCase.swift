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
  
  func getIngList() -> Observable<(title: String, imageData: Data)> {
    let eventTitles = ["e-Gift item 보너스 스타", "BONUS STAR!", "Hyundai Card X STARBUCKS", "오트 밀크를 무료로 만나보세요!", "별 2배!!", "AROUND AUTUMN, AROUND US", "BARISTA FAVORITES", "STARBUCKS | S.I.VILLAGE"]
    var urls = [URL]()
    for i in 1...8 {
      if let url = Bundle.main.url(forResource: "ingimg\(i)", withExtension: "jpg") {
        urls.append(url)
      }
    }
    
    guard urls.isEmpty == false else { return Observable.empty() }
    
    let imageObservable = Observable<URL>.from(urls)
      .flatMap { url in
        URLSession.shared.rx.data(request: URLRequest(url: url))
      }
    
    return Observable<(title: String, imageData: Data)>
      .zip(Observable<String>.from(eventTitles), imageObservable) {
        (title: $0, imageData: $1)
      }
  }
  
  func getThisTimeRecommendList() -> Observable<(title: String?, imageData: Data)> {
    
    var randomBoolean: Bool {
      Int.random(in: 1...10).isMultiple(of: 2)
    }
    
    guard
      let foodsURL = Bundle.main.url(forResource: "food", withExtension: "json"),
      let drinkURL = Bundle.main.url(forResource: "drink", withExtension: "json")
    else {
      return Observable.empty()
    }
    
    let getFoodJSONObservable = URLSession.shared.rx.data(request: URLRequest(url: foodsURL))
      .map({ data -> [StarbucksItemDTO]? in
        let result = try? JSONDecoder().decode(StarbucksArray.self, from: data)
        return result?.foods
      })
    let getDrinkJSONObservable = URLSession.shared.rx.data(request: URLRequest(url: drinkURL))
      .map({ data -> [StarbucksItemDTO]? in
        let result = try? JSONDecoder().decode(StarbucksArray.self, from: data)
        return result?.foods
      })
    
    let entities = Observable<(food: [StarbucksItemDTO], drink: [StarbucksItemDTO])>
      .zip(getFoodJSONObservable, getDrinkJSONObservable) { foods, drinks in
        (food: foods ?? [], drink: drinks ?? [])
      }
    
    var urls = [URL]()

    for indexes in 1...20 {
      
      guard randomBoolean else {
        continue
      }
      
      let title = (randomBoolean ? "food" : "drink") + "\(indexes)"
      if let url = Bundle.main.url(forResource: title, withExtension: "jpg") {
        urls.append(url)
      }
    }
    
    return Observable<URL>
      .from(urls)
      .flatMap { url in
        URLSession.shared.rx.data(request: URLRequest(url: url))
          .map { data in (url, data) }
      }
      .concatMap { result in
        entities
          .map { dto -> (title: String?, imageData: Data) in
            var name = result.0.lastPathComponent
            if let dotIndex = name.firstIndex(of: ".") {
              name.removeSubrange(dotIndex...)
            }
            
            if name.contains("food") {
              return (title: dto.food.first(where: { $0.name == name })?.title, imageData: result.1)
            } else if name.contains("drink") {
              return (title: dto.drink.first(where: { $0.name == name })?.title, imageData: result.1)
            }
            
            return (title: nil, imageData: result.1)
          }
      }
  }
  
  func dispose() { }
}
