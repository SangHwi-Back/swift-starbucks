import Foundation

struct HomeIngDTO: Codable {
  let list: HomeIngList
}

struct HomeIngList: Codable {
  let item: [HomeIngItem]
}

struct HomeIngItem: Codable {
  let title: String
}
