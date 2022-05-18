import RxSwift
import Foundation

class HomeMainUseCase {
  
  private let homeURLSession = HomeURLSession()
  private let imageURLSession = ImageURLSession()
  private let payURLSession = PayURLSession()
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
  
  func getImage(uploadPath: String, mobThum: String) -> Observable<Data> {
    var url = URL(string: uploadPath)
    url?.appendPathComponent("upload")
    url?.appendPathComponent("promotion")
    url?.appendPathComponent(mobThum)
    
    guard let url = url else {
      return Observable<Data>.empty()
    }
    
    return imageURLSession.getStarbucksImage(url)
  }
  
  func getInfo(_ productCd: String, index: Int? = nil) -> Observable<PayItemDTO> {
    return payURLSession.itemInfo(productCd, index).compactMap { [weak self] data in
      return try? self?.decoder.decode(PayItemDTO.self, from: data)
    }
    .asObservable()
  }
  
  func getItemImage(_ productCd: String, index: Int? = nil) -> Observable<PayItemImageDTO> {
    var url = URL(string: "https://www.starbucks.co.kr")
    url?.appendPathComponent("menu")
    url?.appendPathComponent("productFileAjax.do")
    
    guard let url = url else { return Observable<PayItemImageDTO>.empty() }
    
    var urlComp = URLComponents(string: url.absoluteString)
    let index = index == nil ? "" : "\(index!)"
    urlComp?.queryItems = [URLQueryItem(name: "PRODUCT_CD", value: productCd+index)]
    
    guard let url = urlComp?.url else { return Observable<PayItemImageDTO>.empty() }
    
    return imageURLSession.getStarbucksImage(url).compactMap { data in
      return try? self.decoder.decode(PayItemImageDTO.self, from: data)
    }
    
  }
}
