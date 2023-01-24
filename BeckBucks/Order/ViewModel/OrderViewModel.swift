//
//  OrderUseCase.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/20.
//

import Foundation
import RxCocoa
import RxSwift

protocol OrderViewModel {
    var disposeBag: DisposeBag { get }
    var itemBinder: PublishRelay<[StarbucksItemDTO]> { get }
    var items: [StarbucksItemDTO] { get }
    func getImageFrom(rowNumber: Int) -> Driver<Data?>
    func fetchItems()
    func getItem(at index: Int) -> StarbucksItemDTO?
}

extension OrderViewModel {
    func getFoodImageDataTitled(title: String, jsonURL: URL?) -> Observable<[StarbucksItemDTO]> {
        guard let jsonURL else {
            return Observable.error(ViewModelError.urlError(jsonURL.getErrorMessage))
        }
        
        return URLSession.shared.rx
            .response(request: URLRequest(url: jsonURL))
            .map({ result -> [StarbucksItemDTO] in
                if let error = result.response.getRequestError {
                    throw error
                }
                
                guard let result = try? JSONDecoder().decode(StarbucksArray.self, from: result.data) else {
                    throw ViewModelError.decodeFailed(
                        result.response.url.getErrorMessage
                    )
                }
                
                return result.foods
            })
    }
    
    func requestImage(at index: Int) -> Observable<Data?> {
        guard
            index < items.count-1,
            let url = Bundle.main.url(forResource: items[index].fileName,
                                      withExtension: "jpg")
        else {
            return .empty()
        }
        
        if let data = items[index].imageData {
            return Observable.just(data)
        }
        
        return URLSession.shared.rx
            .response(request: URLRequest(url: url))
            .map({ $0.data })
    }
    
    func getItem(at index: Int) -> StarbucksItemDTO? {
        guard index < items.count-1 else {
            return nil
        }
        
        return items[index]
    }
}

private extension Optional where Wrapped == URL {
    var getErrorMessage: String {
        ("Error occured at " + (self?.absoluteString ?? "unkown URL") + ".")
    }
}

private extension HTTPURLResponse {
    var getRequestError: Error? {
        guard self.isSuccess else {
            return ViewModelError.requestError(self.statusCode)
        }
        
        return nil
    }
}
