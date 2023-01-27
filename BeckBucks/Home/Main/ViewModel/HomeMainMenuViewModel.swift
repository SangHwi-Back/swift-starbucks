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
    let foodModel = HomeMainFetchFoodModel()
    let drinkModel = HomeMainFetchDrinkModel()
    
    private(set) var recommendMenus: [StarbucksItemDTO] = []
    let recommendMenuBinder = PublishSubject<[StarbucksItemDTO]>()
    private(set) var currentMenus: [StarbucksItemDTO] = []
    let currentMenuBinder = PublishSubject<[StarbucksItemDTO]>()
    
    init() {
        getRecommendMenu()
        getCurrentMenu()
        foodModel.fetch()
        drinkModel.fetch()
    }
    
    private var disposeBag = DisposeBag()
    
    private func getRecommendMenu() {
        Observable<[StarbucksItemDTO]>.zip(
            foodModel.itemBinder,
            drinkModel.itemBinder
        ) {
            return $0 + $1
        }
        .subscribe(onNext: { [weak self] in
            var result = $0
            result.shuffle()
            result.removeSubrange(0...$0.count)
            
            self?.recommendMenus = result
            self?.recommendMenuBinder.onNext(result)
        })
        .disposed(by: disposeBag)
    }
    
    private func getCurrentMenu() {
        Observable<[StarbucksItemDTO]>.zip(
            foodModel.itemBinder,
            drinkModel.itemBinder
        ) {
            return $0 + $1
        }
        .subscribe(onNext: { [weak self] in
            var result = $0
            result.shuffle()
            result.removeSubrange(0...$0.count)
            
            self?.currentMenus = result
            self?.currentMenuBinder.onNext(result)
        })
        .disposed(by: disposeBag)
    }
}
