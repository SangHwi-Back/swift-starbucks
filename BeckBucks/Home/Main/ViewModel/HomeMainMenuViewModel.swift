//
//  HomeMainMenuViewModel.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/27.
//

import Foundation
import RxSwift
import RxCocoa

class HomeMainMenuViewModel: StarbucksViewModel<StarbucksItemDTO> {
    enum EntityType {
        case recommend
        case current
    }
    
    private let foodModel = HomeMainFetchFoodModel()
    private let drinkModel = HomeMainFetchDrinkModel()
    
    private(set) var recommendMenus: [Entity] = []
    let recommendMenuBinder = PublishSubject<[Entity]>()
    private(set) var currentMenus: [Entity] = []
    let currentMenuBinder = PublishSubject<[Entity]>()
    
    override init() {
        super.init()
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
    
    /// Deactivated. Use getItem(at: Int, type: EntityType).
//    override func getItem(at index: Int) -> Entity? {
//        return nil
//    }
    
    func getItem(at index: Int, type: EntityType) -> Entity? {
        switch type {
        case .recommend:
            return index < recommendMenus.count ? recommendMenus[index] : nil
        case .current:
            return index < currentMenus.count ? currentMenus[index] : nil
        }
    }
}
