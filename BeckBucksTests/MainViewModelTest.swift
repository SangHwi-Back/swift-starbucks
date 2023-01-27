import XCTest
import RxSwift
import RxCocoa

class MainViewModelTest: XCTestCase {
    
    let mainVM = HomeMainViewModel()
    let menuVM = HomeMainMenuViewModel()
    
    private var disposeBag = DisposeBag()
    
    func test_mainInfo_getItems() {
        
        let expect = XCTestExpectation.withCount(1)
        
        mainVM.itemBinder
            .subscribe(onNext:{
                print("PRINT IN TEST : item count is \($0.whatsNewList.count)")
                expect.fulfill()
            })
            .disposed(by: disposeBag)
        
        mainVM.fetch()
        
        wait(for: [expect], timeout: 3.0)
    }
    
    func test_mainMenu_getItems() {
        
        let expect = XCTestExpectation.withCount(2)
        
        menuVM.recommendMenuBinder
            .subscribe(onNext:{
                
                print("PRINT IN TEST :", $0.map({ item in item.id }))
                
                if $0.isEmpty == false, $0.isInOrder() == false {
                    expect.fulfill()
                }
            })
            .disposed(by: disposeBag)
        
        menuVM.currentMenuBinder
            .subscribe(onNext:{
                
                print("PRINT IN TEST :", $0.map({ item in item.id }))
                
                if $0.isEmpty == false, $0.isInOrder() == false {
                    expect.fulfill()
                }
            })
            .disposed(by: disposeBag)
        
        menuVM.fetch()
        
        wait(for: [expect], timeout: 3.0)
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
