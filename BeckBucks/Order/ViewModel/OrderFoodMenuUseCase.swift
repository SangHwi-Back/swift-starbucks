//
//  OrderFoodMenuUseCase.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/09.
//

import Foundation
import RxCocoa
import RxSwift

class OrderFoodMenuUseCase: OrderViewModel {
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
    
    func resetItems() {
        items.removeAll()
        fetchItems()
    }
    
    func getImageFrom(rowNumber: Int) -> Driver<Data?> {
        let observable = requestImage(at: rowNumber)
        
        return observable
            .do(onNext: { [weak self] in self?.items[rowNumber].imageData = $0 })
            .asDriver(onErrorJustReturn: nil)
    }
    
    func getItemTitle(rowNumber: Int) -> String? {
        guard rowNumber < items.count else { return nil }
        return items[rowNumber].title
    }
    
    func fetchItems() {
        guard let url = Bundle.main.url(forResource: "food", withExtension: "json") else {
            return
        }
        
        getFoodImageDataTitled(title: "food", jsonURL: url)
            .subscribe(onNext: { [weak self] entities in
                self?.items = entities
            })
            .disposed(by: disposeBag)
    }
}

