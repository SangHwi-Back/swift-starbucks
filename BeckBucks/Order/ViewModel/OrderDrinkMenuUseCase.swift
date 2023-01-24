//
//  OrderDrinkMenuUseCase.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/20.
//

import Foundation
import RxSwift
import RxCocoa

class OrderDrinkMenuUseCase: OrderViewModel {
    let disposeBag = DisposeBag()
    let itemBinder = PublishRelay<[StarbucksItemDTO]>()
    
    private(set) var items: [StarbucksItemDTO] = []
    
    init() {
        fetchItems()
        URLProtocol.registerClass(HTTPRequestMockProtocol.self)
    }
    
    deinit {
        URLProtocol.unregisterClass(HTTPRequestMockProtocol.self)
    }
    
    func getImageFrom(rowNumber: Int) -> Driver<Data?> {
        let observable = requestImage(at: rowNumber)
        
        return observable
            .do(onNext: { [weak self] in self?.items[rowNumber].imageData = $0 })
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

