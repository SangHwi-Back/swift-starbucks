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
    return homeURLSession.ingList.compactMap { [weak self] data in
      try? self?.decoder.decode(HomeIngDTO.self, from: data)
    }
  }
  
  func getStoredImageData(uploadPath: String, mobThum: String) -> Observable<Data> {
    var url = URL(string: uploadPath)
    url?.appendPathComponent("upload")
    url?.appendPathComponent("promotion")
    url?.appendPathComponent(mobThum)
    
    guard let url = url else {
      return Observable<Data>.empty()
    }
    
    var request = URLRequest.common(url)
    request.httpMethod = "GET"
    
    return imageURLSession.getStarbucksImage(request)
  }
  
  func getStoredItemInfo(key productCd: String, index: Int? = nil) -> Observable<PayItemDTO> {
    return payURLSession.itemInfo(productCd, index).compactMap { [weak self] data in
      return try? self?.decoder.decode(PayItemDTO.self, from: data)
    }
    .asObservable()
  }
  
  func getItemImageInfo(_ productCd: String, index: Int? = nil) -> Observable<PayItemImageDTO> {
    let index = index == nil ? "" : "\(index!)"
    
    return payURLSession.getImageInfo(productCd+index).compactMap { data in
      return try? self.decoder.decode(PayItemImageDTO.self, from: data)
    }
    .asObservable()
  }
  
  func getStoredJSONAndData(JSONname: String, index: Int) -> Observable<(PayItemImageFile, Data, Int)> {
    
    let imageInfoObservable: Observable<(PayItemImageDTO, Int)> = Observable<String>.just("").flatMap { _ in
      return self.getItemImageInfo(JSONname, index: index)
        .map({(elem) in (elem, index)})
    }
    
    let result = imageInfoObservable
      .flatMap { (dto, index) -> Observable<(PayItemImageFile, Data)> in
        guard let info = dto.file.first else {
          return Observable<(PayItemImageFile, Data)>.empty()
        }
        
        return self.getStoredImageData(uploadPath: info.img_UPLOAD_PATH, mobThum: info.file_NAME)
          .map({ data in (info, data) })
      }
    
    return result.map({ (info, data) in (info, data, index) })
  }
}
