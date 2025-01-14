import Foundation

struct HomeIngDTO: Codable {
  let list: [HomeIngItem]
}

struct HomeIngList: Codable {
  let item: [HomeIngItem]
}

struct HomeIngItem: Codable {
  let title: String
  let mob_THUM: String
  let img_UPLOAD_PATH: String
  let sbtitle_NAME: String
}
