import Foundation

struct PayItemImageDTO: Codable {
  let file: [PayItemImageFile]
}

struct PayItemImageFile:Codable {
  let img_UPLOAD_PATH: String
  let file_PATH: String
  let file_NAME: String
}
