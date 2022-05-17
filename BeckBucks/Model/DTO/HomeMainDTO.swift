import Foundation

struct HomeMainDTO: Codable {
  let displayName: String
  let yourRecommend: HomeMainProducts
  let mainEvent: HomeMainEvent
  let nowRecommand: HomeMainProducts
}

struct HomeMainProducts: Codable {
  let products: [String]
}

struct HomeMainEvent: Codable {
  let imgUploadPath: String
  let mobThumb: String
}
