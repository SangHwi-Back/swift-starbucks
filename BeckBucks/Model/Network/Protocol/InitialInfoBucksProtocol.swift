import Foundation
import RxSwift

class InitialInfoBucksProtocol: CommonBucksProtocol {
  override var resourceName: String {
    "InitialJSON"
  }
  
  override var resourceExtension: String {
    "json"
  }
}
