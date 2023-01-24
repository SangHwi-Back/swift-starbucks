import RxSwift
import RxCocoa
import Foundation

enum ViewModelError: Error {
  case testError
  case urlError(String)
  case decodeFailed(String)
  case requestError(Int)
}

class HomeMainViewModel {
  
  init() {
    URLProtocol.registerClass(HTTPRequestMockProtocol.self)
  }
  
  deinit {
    URLProtocol.unregisterClass(HTTPRequestMockProtocol.self)
  }
  
  private let model = HTTPRequestMockModel()
  private let decoder = JSONDecoder()
  private var disposeBag = DisposeBag()
  
  private var recommendationURL: URL? {
    Bundle.main.url(forResource: "recommendation", withExtension: "json")
  }
  
  private var imageOfRecommendationItemURL: (Int) -> URL? = { num in
    Bundle.main.url(forResource: "recommendation\(num)", withExtension: "jpg")
  }
  
  private var homeMainImageURL: URL? {
    Bundle.main.url(forResource: "homeMainImage", withExtension: "jpg")
  }
  
  private var thumbnailImageDataURL: URL? {
    Bundle.main.url(forResource: "homeMainThumbImage", withExtension: "jpg")
  }
  
  private var ingImageURL: (Int) -> URL? = { num in
    Bundle.main.url(forResource: "ingimg\(num)", withExtension: "jpg")
  }
  
  private let ingListTitles = ["e-Gift item 보너스 스타", "BONUS STAR!", "Hyundai Card X STARBUCKS", "오트 밀크를 무료로 만나보세요!", "별 2배!!", "AROUND AUTUMN, AROUND US", "BARISTA FAVORITES", "STARBUCKS | S.I.VILLAGE"]
  
  private var foodsURL: URL? {
    Bundle.main.url(forResource: "food", withExtension: "json")
  }
  
  private var drinksURL: URL? {
    Bundle.main.url(forResource: "drink", withExtension: "json")
  }
  
  private var randomBoolean: Bool {
    Int.random(in: 1...10).isMultiple(of: 2)
  }
  
  func getRecommendationsForUser() -> Observable<TitledImageData> {
    guard let recommendationURL else { return Observable.error(ViewModelError.urlError("recommendation.json")) }
    
    let itemTitleObservable = URLSession.shared.rx.response(request: URLRequest(url: recommendationURL))
      .flatMap({ request -> Observable<String> in
        if let error = request.response.getRequestError { throw error }
        guard let result = try? JSONDecoder().decode(StarbucksArray.self, from: request.data) else {
          throw ViewModelError.decodeFailed(request.response.url.getErrorMessage)
        }
        
        return Observable<String>.from(result.foods.map({$0.title}))
      })
    
    let imageDataObservable = Observable<Int>.from(1...4)
      .flatMap({ [weak self] num -> Observable<Data> in
        guard let url = self?.imageOfRecommendationItemURL(num) else {
          throw ViewModelError.urlError("recommendation\(num).jpg")
        }
        
        return URLSession.shared.rx.data(request: URLRequest(url: url))
      })
    
    return Observable<TitledImageData>
      .zip(itemTitleObservable, imageDataObservable) {
        TitledImageData(title: $0, data: $1)
      }
  }
  
  func getMainInfo() -> Single<Data> {
    model.getImage(from: homeMainImageURL)
  }
  
  func getThumbDataImage() -> Single<Data> {
    model.getImage(from: thumbnailImageDataURL)
  }
  
  func getIngList() -> Observable<TitledImageData> {
    Observable<String>.from(ingListTitles)
      .enumerated()
      .flatMap({ [weak self] (index, title) -> Observable<TitledImageData> in
        guard let url = self?.ingImageURL(index+1), let title = self?.ingListTitles[index] else {
          throw ViewModelError.urlError("ingimg\(index+1).jpg")
        }
        
        return URLSession.shared.rx.response(request: URLRequest(url: url))
          .map({ (response, data) -> TitledImageData in
            if let error = response.getRequestError { throw error }
            return TitledImageData(title: title, data: data)
          })
      })
  }
  
  private func getThisTimeRecommendList(_ url: URL) -> Observable<StarbucksItemDTO> {
    URLSession.shared.rx.response(request: URLRequest(url: url))
      .map({ request -> StarbucksArray in
        if let error = request.response.getRequestError { throw error }
        if let result = try? JSONDecoder().decode(StarbucksArray.self, from: request.data) {
          return result
        }
        
        throw ViewModelError.decodeFailed(request.response.url.getErrorMessage)
      })
      .flatMap({
        return Observable<StarbucksItemDTO>.from($0.foods)
      })
  }
  
  func getThisTimeRecommendList() -> Observable<TitledImageData> {
    guard let foodsURL else { return Observable.error(ViewModelError.urlError("food.json")) }
    guard let drinksURL else { return Observable.error(ViewModelError.urlError("drink.json")) }
    
    let entities = Observable<(number: Int, food: StarbucksItemDTO, drink: StarbucksItemDTO)>
      .zip(getThisTimeRecommendList(foodsURL).enumerated(), getThisTimeRecommendList(drinksURL)) {
        (number: $0.index+1, food: $0.element, drink: $1)
      }
    
    var getRandomTitle: String {
      (self.randomBoolean ? "food" : "drink")
    }
    
    return entities.flatMap({ entityInfo in
      let title = getRandomTitle
      
      guard let url = Bundle.main.url(forResource: title+"\(entityInfo.number)", withExtension: "jpg") else {
        throw ViewModelError.urlError(title+"\(entityInfo.number).jpg")
      }
      
      return URLSession.shared.rx.response(request: URLRequest(url: url))
        .map { request in
          if let error = request.response.getRequestError { throw error }
          return TitledImageData(
            title: (title == "food" ? entityInfo.food.title : entityInfo.drink.title),
            data: request.data
          )
        }
    })
  }
  
  struct TitledImageData {
    let title: String
    let data: Data
  }
}

private extension HTTPURLResponse {
  var getRequestError: Error? {
    guard self.isSuccess else {
      return nil
    }
    
    return ViewModelError.requestError(self.statusCode)
  }
}

private extension Optional where Wrapped == URL {
  var getErrorMessage: String {
    ("Error occured at " + (self?.absoluteString ?? "unkown URL") + ".")
  }
}
