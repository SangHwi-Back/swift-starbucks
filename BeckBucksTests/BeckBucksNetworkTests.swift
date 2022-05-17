import XCTest
import RxSwift
@testable import BeckBucks

class BeckBucksNetworkTests: XCTestCase {
  
  func testExample() {
    let bag = DisposeBag()
    let useCase = InitialEventUseCase()
    
    let infoExpectation = XCTestExpectation()
    let imageExpectation = XCTestExpectation()
    
    useCase.initialURLSession.info
      .subscribe(onNext: { data in
        let result = try? JSONDecoder().decode(InitialDTO.self, from: data)
        XCTAssertTrue(result != nil)
        infoExpectation.fulfill()
      })
      .disposed(by: bag)
    
    useCase.initialURLSession.image
      .subscribe(onNext: { data in
        let result = UIImage(data: data)
        XCTAssertTrue(result != nil)
        imageExpectation.fulfill()
      })
      .disposed(by: bag)
    
    wait(for: [infoExpectation, imageExpectation], timeout: 5)
  }

}
