import Foundation

struct HomeMainDTO: Codable {
  let displayName: String
  let yourRecommend: HomeMainProducts
  let mainEvent: HomeMainEvent
  let nowRecommend: HomeMainProducts
  
  enum CodingKeys: String, CodingKey {
    case displayName = "display-name"
    case yourRecommend = "your-recommand"
    case mainEvent = "main-event"
    case nowRecommend = "now-recommand"
  }
}

struct HomeMainProducts: Codable {
  let products: [String]
}

struct HomeMainEvent: Codable {
  let img_UPLOAD_PATH: String
  let mob_THUM: String
}
