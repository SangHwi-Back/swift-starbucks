//
//  OrderDrinkMenuUseCase.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/20.
//

import Foundation
import RxSwift
import RxCocoa

class OrderDrinkMenuUseCase: OrderUseCase {
    let disposeBag = DisposeBag()
    let itemBinder = PublishRelay<[StarbucksItemDTO]>()
    
    private(set) var items: [StarbucksItemDTO] = []
    
    init() {
        URLProtocol.registerClass(HTTPRequestMockProtocol.self)
    }
    
    deinit {
        URLProtocol.unregisterClass(HTTPRequestMockProtocol.self)
    }
    
    func getImageFrom(rowNumber: Int) -> Driver<UIImage?> {
        guard
            rowNumber < items.count,
            let url = Bundle.main.url(forResource: items[rowNumber].name,
                                      withExtension: "jpg")
        else {
            return .empty()
        }
        
        return URLSession.shared.rx
            .response(request: URLRequest(url: url))
            .map({ UIImage(data: $0.data) })
            .asDriver(onErrorJustReturn: nil)
    }
    
    func fetchItems() {
        guard let url = Bundle.main.url(forResource: "drink", withExtension: "json") else {
            return
        }
        
        getFoodImageDataTitled(title: "drink", jsonURL: url)
            .subscribe(onNext: { [weak self] entities in
                self?.items = entities
            })
            .disposed(by: disposeBag)
    }
}

