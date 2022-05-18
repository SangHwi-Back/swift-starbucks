import Foundation

class PayItemBucksProtocol: CommonBucksProtocol {
  override var resourceName: String {
    var result = "payItemJSON"
    if let index = PayItemBucksProtocol.fileIndex {
      result = result + "\(index)"
    }
    
    return result
  }
  
  override var resourceExtension: String {
    "json"
  }
  
  static var fileIndex: Int?
}
