import Foundation
import RxSwift

class HomeURLSession {

  // MARK: - URLs
  
  private var homeMainURL: URL
  private var mainThumbURL: URL
  private var ingListURL: URL
  
  init() {
    homeMainURL = URL(string: "https://api.codesquad.kr")!
    homeMainURL.appendPathComponent("starbuckst")
    
    mainThumbURL = URL(string: "https://image.istarbucks.co.kr")!
    mainThumbURL.appendPathComponent("upload")
    mainThumbURL.appendPathComponent("promotion")
    mainThumbURL.appendPathComponent("APP_THUM_20210719090612417.jpg")
    
    ingListURL = URL(string: "https://www.starbucks.co.kr")!
    ingListURL.appendPathComponent("whats_new")
    ingListURL.appendPathComponent("getIngList.do")
  }
  
  // MARK: - Observables
  
  var main: Observable<Data> {
    return URLSession(configuration: HomeMainBucksProtocol.protocolClass).rx
      .data(request: URLRequest(url: homeMainURL))
      .share(replay: 1)
  }
  
  var thumb: Observable<Data> {
    return URLSession(configuration: HomeThumbBucksProtocol.protocolClass).rx
      .data(request: URLRequest(url: mainThumbURL))
      .share(replay: 1)
  }
  
  var ingList: Observable<Data> {
    
    var request = URLRequest(url: ingListURL)
    request.httpMethod = "POST"
    request.httpBody = "MENU_CD=all".data(using: .utf8)
    request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    request.addValue("utf-8", forHTTPHeaderField: "charset")
    
    return URLSession(configuration: HomeIngBucksProtocol.protocolClass).rx
      .data(request: URLRequest(url: ingListURL))
      .share(replay: 1)
  }
}
