import XCTest
import RxSwift
@testable import BeckBucks

class BeckBucksNetworkTests: XCTestCase {
  
  let bag = DisposeBag()
  
  func test_initialUseCase_functionality() {
    let useCase = InitialEventUseCase()
    
    let infoExpectation = XCTestExpectation()
    let imageExpectation = XCTestExpectation()
    wait(for: [infoExpectation, imageExpectation], timeout: 6)
  }
  
  func test_homeUseCase_functionality() {
    let useCase = HomeMainUseCase()
    let expect = XCTestExpectation()
    expect.expectedFulfillmentCount = 4
    wait(for: [expect], timeout: .greatestFiniteMagnitude)
  }

}
