import XCTest
import RxSwift
import RxCocoa

class MainViewModelTest: XCTestCase {
    let viewModel = HomeViewModel()
    var disposeBag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        viewModel.currentIndex = 0
    }
    
    func test_viewModel() throws {
        // MARK: - Arrange
        var currentSubject: BehaviorSubject<[MainItemDTO]>?
        
        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 6
        
        let testSubject = PublishSubject<Int>()
        
        testSubject
            .do(onNext: { _ in
                expectation.fulfill()
            })
            .bind(to: viewModel.rx.indexBindable)
            .disposed(by: disposeBag)
        viewModel
            .indexSubject
            .subscribe(onNext: { subject in
                expectation.fulfill()
                currentSubject = subject
            })
            .disposed(by: disposeBag)
        
        // MARK: - Action
        for i in 1...3 {
            testSubject.onNext(i)
        }
        
        // MARK: - Assert
        wait(for: [expectation], timeout: 3.0)
        XCTAssertNotNil(currentSubject)
    }
    
    func test_indexMinRange() throws {
        
        viewModel.currentIndex = -1
        XCTAssertEqual(viewModel.currentIndex, 0)
    }
    
    func test_indexMaxRange() throws {
        
        viewModel.currentIndex = 3
        XCTAssertEqual(viewModel.currentIndex, 0)
    }
    
    func test_indexRange() throws {
        
        for i in 0...2 {
            
            viewModel.currentIndex = i
            XCTAssertEqual(viewModel.currentIndex, i)
        }
    }
}

private extension Array where Element == StarbucksItemDTO {
    func isInOrder() -> Bool {
        var currentKey = 0
        
        for item in self {
            guard let key = Int(item.id) else {
                return false
            }
            
            if currentKey + 1 == key {
                currentKey = key
                continue
            } else {
                return false
            }
        }
        
        return true
    }
}
