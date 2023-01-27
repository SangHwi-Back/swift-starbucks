//
//  HomeMainFetchDrinkModel.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/27.
//

import Foundation
import RxSwift
import RxCocoa

class HomeMainFetchDrinkModel: JSONFetchable {
    var jsonName: String?
    
    private(set) var items: [StarbucksItemDTO] = []
    let itemBinder = PublishSubject<[StarbucksItemDTO]>()
    private(set) var disposeBag = DisposeBag()
    
    init() {
        self.jsonName = "drink"
    }
    
    func fetch() {
        getJSONFetchObservable()
            .subscribe(onNext: { [weak self] result in
                if let error = result.response.getRequestError {
                    self?.itemBinder.onError(error)
                    return
                }
                
                do {
                    let entity = (try JSONDecoder().decode(StarbucksArray.self, from: result.data)).foods
                    self?.items = entity
                    self?.itemBinder.onNext(entity)
                } catch {
                    self?.itemBinder.onError(error)
                }
            })
            .disposed(by: disposeBag)
    }
}
