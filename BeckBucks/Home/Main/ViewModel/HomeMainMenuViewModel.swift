//
//  HomeMainMenuViewModel.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/27.
//

import Foundation
import RxSwift
import RxCocoa

class HomeMainMenuViewModel {
    private let foodModel = HomeMainFetchFoodModel()
    private let drinkModel = HomeMainFetchDrinkModel()
    
    private(set) var recommendMenus: [StarbucksItemDTO] = []
    let recommendMenuBinder = PublishSubject<[StarbucksItemDTO]>()
    private(set) var currentMenus: [StarbucksItemDTO] = []
    let currentMenuBinder = PublishSubject<[StarbucksItemDTO]>()
    
    private var disposeBag = DisposeBag()
    
    init() {
        bindMenuModels()
    }
    
    func fetch() {
        foodModel.fetch()
        drinkModel.fetch()
    }
    
    private func bindMenuModels() {
        Observable<[StarbucksItemDTO]>.zip(
            foodModel.itemBinder,
            drinkModel.itemBinder
        ) {
            return $0 + $1
        }
        .subscribe(onNext: { [weak self] in
            let randomValue = (2...5).randomElement() ?? 2
            var result = $0
            result.shuffle()
            result.removeSubrange(0...$0.count/randomValue)
            
            self?.recommendMenus = result
            self?.recommendMenuBinder.onNext(result)
        })
        .disposed(by: disposeBag)
        
        Observable<[StarbucksItemDTO]>.zip(
            foodModel.itemBinder,
            drinkModel.itemBinder
        ) {
            return $0 + $1
        }
        .subscribe(onNext: { [weak self] in
            let randomValue = (2...5).randomElement() ?? 2
            var result = $0
            result.shuffle()
            result.removeSubrange(0...$0.count/randomValue)
            
            self?.currentMenus = result
            self?.currentMenuBinder.onNext(result)
        })
        .disposed(by: disposeBag)
    }
}
