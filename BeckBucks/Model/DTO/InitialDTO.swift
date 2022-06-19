import Foundation

struct InitialDTO: Codable {
  let title: String
  let range: String
  let target: String
  let description: String
  let eventProducts: String
  
  enum CodingKeys: String, CodingKey {
    case title
    case range
    case target
    case description
    case eventProducts = "event-products"
  }
  
  static let empty = Self.init(title: "", range: "", target: "", description: "", eventProducts: "")
}
