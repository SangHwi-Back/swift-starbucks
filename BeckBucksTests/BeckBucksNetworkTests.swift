import XCTest
import RxSwift
@testable import BeckBucks

class BeckBucksNetworkTests: XCTestCase {
  
  func test_initialUseCase_functionality() {
    let bag = DisposeBag()
    let useCase = InitialEventUseCase()
    
    let infoExpectation = XCTestExpectation()
    let imageExpectation = XCTestExpectation()
    
    useCase.getInitialInfo()
      .subscribe(onNext: { data in
        infoExpectation.fulfill()
      })
      .disposed(by: bag)
    
    useCase.getBackgroundImage()
      .subscribe(onNext: { data in
        let result = UIImage(data: data)
        XCTAssertTrue(result != nil)
        imageExpectation.fulfill()
      })
      .disposed(by: bag)
    
    wait(for: [infoExpectation, imageExpectation], timeout: 6)
  }

}
