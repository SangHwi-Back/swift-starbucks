//
//  OrderAllMenuUseCase.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/09.
//

import Foundation
import RxCocoa
import RxSwift

class OrderAllMenuUseCase {
    private(set) var items = [StarbucksItemDTO]() {
        didSet {
            self.itemBinder.onNext(items)
        }
    }
    var disposeBag = DisposeBag()
    
    lazy var itemBinder = PublishSubject<[StarbucksItemDTO]>()
    
    func bindRequestedImage(rowNumber: Int) -> Observable<UIImage?> {
        guard
            0..<items.count ~= rowNumber,
            let url = Bundle.main.url(forResource: items[rowNumber].name,
                                      withExtension: "jpg")
        else {
            return .empty()
        }
        
        return URLSession.shared.rx
            .response(request: URLRequest(url: url))
            .map({ UIImage(data: $0.data) })
    }
    
    func getItemTitle(rowNumber: Int) -> String? {
        guard 0..<items.count ~= rowNumber else {
            return nil
        }
        
        return items[rowNumber].title
    }
    
    func resolveUI(_ jsonTitle: String) {
        let url = Bundle.main.url(forResource: jsonTitle, withExtension: "json")
        getFoodImageDataTitled(title: jsonTitle, jsonURL: url)
            .subscribe(onNext: { entities in
                self.items.append(contentsOf: entities)
            })
            .disposed(by: disposeBag)
    }
    
    private func getFoodImageDataTitled(title: String, jsonURL: URL?) -> Observable<[StarbucksItemDTO]> {
        guard let jsonURL else {
            return Observable.error(UseCaseError.urlError(jsonURL.getErrorMessage))
        }
        
        return URLSession.shared.rx.response(request: URLRequest(url: jsonURL))
            .map({ result -> [StarbucksItemDTO] in
                if let error = result.response.getRequestError {
                    throw error
                }
                
                guard let result = try? JSONDecoder().decode(StarbucksArray.self, from: result.data) else {
                    throw UseCaseError.decodeFailed(result.response.url.getErrorMessage)
                }
                
                return result.foods
            })
    }
}

private extension HTTPURLResponse {
    var getRequestError: Error? {
        guard self.isSuccess else {
            return UseCaseError.requestError(self.statusCode)
        }
        
        return nil
    }
}

private extension Optional where Wrapped == URL {
    var getErrorMessage: String {
        ("Error occured at " + (self?.absoluteString ?? "unkown URL") + ".")
    }
}

