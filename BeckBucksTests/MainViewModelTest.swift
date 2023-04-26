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
        // MARK: - test_viewModel.Arrange
        let expectation = XCTestExpectation()
        expectation.expectedFulfillmentCount = 6
        
        ///   Test Reactive extension for **currentIndex**.
        let testSubject = PublishSubject<Int>()
        testSubject
            .do(afterNext: { _ in expectation.fulfill()})
            .bind(to: viewModel.rx.indexBindable) // Here is Target.
            .disposed(by: disposeBag)
        
        ///   Test Reactive extension for **itemBinderByIndex**.
        viewModel.rx.itemBinderByIndex
            .bind { relay in
                guard let relay else { return }
                self.localBind(relay, to: expectation) // Here is Target.
            }
            .disposed(by: disposeBag)
        
        // MARK: - test_viewModel.Action
        for i in 1...3 {
            testSubject.onNext(i)
        }
        
        // MARK: - test_viewModel.Assert
        wait(for: [expectation], timeout: 3.0)
    }
    
    private func localBind(_ relay: BehaviorRelay<[HomeViewModel.DTO]>, to expectation: XCTestExpectation) {
        relay
            .subscribe(onNext: { items in
                if items.isEmpty == false {
                    expectation.fulfill()
                }
            })
            .disposed(by: disposeBag)
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
