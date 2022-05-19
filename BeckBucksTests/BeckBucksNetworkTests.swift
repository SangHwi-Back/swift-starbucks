import XCTest
import RxSwift
@testable import BeckBucks

class BeckBucksNetworkTests: XCTestCase {
  
  let bag = DisposeBag()
  
  func test_initialUseCase_functionality() {
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
  
  func test_homeUseCase_functionality() {
    let useCase = HomeMainUseCase()
    let expect1 = XCTestExpectation()
    let expect2 = XCTestExpectation()
    let expect3 = XCTestExpectation()
    let expect4 = XCTestExpectation()
    
    useCase.getMainInfo()
      .subscribe(onNext: { dto in
        
        // 사용자 이름
        XCTAssertNotEqual(dto.displayName, "")
        
        // 추천 메뉴
        Observable.from(dto.yourRecommend.products)
          .enumerated()
          .flatMap({ (index, productCd) in
            useCase.getItemImageInfo("payImageJSON", index: index)
          })
          .compactMap({ imageDTO in
            imageDTO.file.first
          })
          .flatMap({ imageDTO -> Observable<Data> in
            useCase.getStoredImageData(uploadPath: imageDTO.img_UPLOAD_PATH, mobThum: imageDTO.file_NAME)
          })
          .subscribe(onNext: { imageData in
            XCTAssertNotNil(UIImage(data: imageData))
            expect1.fulfill()
          })
          .disposed(by: self.bag)
        
        Observable.from(dto.nowRecommend.products)
          .enumerated()
          .flatMap({ (index, productCd) in
            useCase.getItemImageInfo("payImageJSON", index: index)
          })
          .compactMap({ imageDTO in
            imageDTO.file.first
          })
          .flatMap({ imageDTO -> Observable<Data> in
            useCase.getStoredImageData(uploadPath: imageDTO.img_UPLOAD_PATH, mobThum: imageDTO.file_NAME)
          })
          .subscribe(onNext: { imageData in
            XCTAssertNotNil(UIImage(data: imageData))
            expect2.fulfill()
          })
          .disposed(by: self.bag)
        
      })
      .disposed(by: bag)
    
    useCase.getThumbDataImage()
      .subscribe(onNext: { imageData in
        XCTAssertNotNil(UIImage(data: imageData))
        expect3.fulfill()
      })
      .disposed(by: bag)

    useCase.getIngList()
      .flatMap({ dto in
        Observable.from(dto.list)
      })
      .flatMap({ itemDTO in
        useCase.getStoredImageData(uploadPath: itemDTO.img_UPLOAD_PATH, mobThum: itemDTO.mob_THUM)
      })
      .subscribe(onNext: { imageData in
        XCTAssertNotNil(UIImage(data: imageData))
        expect4.fulfill()
      })
      .disposed(by: bag)
    
    wait(for: [expect1, expect2, expect3, expect4], timeout: .greatestFiniteMagnitude)
  }

}
