import RxSwift
import Foundation

enum UseCaseError: Error {
  case testError
}

class HomeMainUseCase {
  
  private let homeURLSession = HomeURLSession()
  private let imageURLSession = ImageURLSession()
  private let payURLSession = PayURLSession()
  private let decoder = JSONDecoder()
  
  func getMainInfo() -> Observable<HomeMainDTO?> {
    guard let session = homeURLSession.main else {
      return .empty()
    }
    
    return session.compactMap { [weak self] data in
      try? self?.decoder.decode(HomeMainDTO.self, from: data)
    }.asObservable()
  }
  
  func getThumbDataImage() -> Observable<Data>? {
    return homeURLSession.thumb
  }
  
  func getIngList() -> Observable<HomeIngDTO>? {
    return homeURLSession.ingList?.compactMap { [weak self] data in
      try? self?.decoder.decode(HomeIngDTO.self, from: data)
    }
  }
  
  func getStoredImageData(uploadPath: String, mobThum: String) -> Observable<Data>? {
    guard var url = URL(string: uploadPath) else {
      return nil
    }
    
    url.appendPathComponent("upload")
    url.appendPathComponent("promotion")
    url.appendPathComponent(mobThum)
    
    return imageURLSession.getStarbucksImage(URLRequest.common(url))
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
  
  func getStoredJSONAndImageData(JSONname: String, index: Int) -> Observable<(PayItemImageFile, Data, Int)> {
    getItemImageInfo(JSONname, index: index)
      .map({(elem) in (elem, index)})
      .flatMap { (dto, index) -> Observable<(PayItemImageFile, Data, Int)> in
        guard
          let info = dto.file.first,
          let ob = self.getStoredImageData(uploadPath: info.img_UPLOAD_PATH, mobThum: info.file_NAME)
        else {
          return Observable<(PayItemImageFile, Data, Int)>.empty()
        }
        
        return ob.map({ data in (info, data, index) })
      }
  }
  
  func getStoredImageData(JSONname: String, index: Int) -> Observable<Data> {
    getItemImageInfo(JSONname, index: index)
      .flatMap { dto -> Observable<Data> in
        guard
          let info = dto.file.first,
          let ob = self.getStoredImageData(uploadPath: info.img_UPLOAD_PATH, mobThum: info.file_NAME)
        else {
          return Observable.empty()
        }
        
        return ob
      }
  }
  
  func dispose() { }
}
