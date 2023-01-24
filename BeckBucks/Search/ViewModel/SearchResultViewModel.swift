//
//  SearchResultViewModel.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/23.
//

import Foundation
import RxSwift
import RxCocoa

class SearchResultViewModel {
    
    var disposeBag = DisposeBag()
    let itemsRelay = PublishRelay<[StarbucksItemDTO]>()
    private var items: [StarbucksItemDTO] = [] {
        didSet {
            itemsRelay.accept(items)
        }
    }
    
    init() {
        URLProtocol.registerClass(HTTPRequestMockProtocol.self)
    }
    
    deinit {
        URLProtocol.unregisterClass(HTTPRequestMockProtocol.self)
    }
    
    func getTestData() {
        fetchItems(jsonName: "food")
        fetchItems(jsonName: "drink")
    }
    
    func requestImage(at index: Int) -> Observable<Data?> {
        
        guard 0..<items.count ~= index else {
            return .empty()
        }
        
        if let data = items[index].imageData {
            return Observable.just(data)
        }
        
        guard let url = Bundle.main.url(forResource: items[index].fileName, withExtension: "jpg") else {
            return .empty()
        }
        
        return URLSession.shared.rx
            .response(request: URLRequest(url: url))
            .map({ $0.data })
            .do(onNext: { [weak self] in self?.items[index].imageData = $0 })
    }
    
    func fetchItems(jsonName: String) {
        guard let url = Bundle.main.url(forResource: jsonName, withExtension: "json") else {
            return
        }
        
        getFoodImageDataTitled(jsonURL: url)
            .subscribe(onNext: { [weak self] entities in
                self?.items.append(contentsOf: entities)
            })
            .disposed(by: disposeBag)
    }
    
    private func getFoodImageDataTitled(jsonURL: URL?) -> Observable<[StarbucksItemDTO]> {
        guard let jsonURL else {
            return .empty()
        }
        
        return URLSession.shared.rx
            .response(request: URLRequest(url: jsonURL))
            .map({ result -> [StarbucksItemDTO] in
                guard let result = try? JSONDecoder().decode(StarbucksArray.self, from: result.data) else {
                    return []
                }
                
                return result.foods
            })
    }
}
