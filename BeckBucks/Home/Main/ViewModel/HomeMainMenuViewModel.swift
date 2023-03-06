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
        case recommend, current
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
        typealias RESULT = (type: EntityType, result: [StarbucksItemDTO])

        let getObservable: (EntityType) -> Observable<RESULT> = { type in
            return .zip(self.foodModel.itemBinder, self.drinkModel.itemBinder) {
                return (type: type, result: $0 + $1)
            }
        }

        Observable<RESULT>
            .merge([getObservable(.recommend), getObservable(.current)])
            .subscribe(onNext: { [weak self] in
                var result = $0.result
                result = result.shuffleAndRemove()

                switch $0.type {
                case .recommend:
                    self?.recommendMenus = result
                    self?.recommendMenuBinder.onNext(result)
                case .current:
                    self?.currentMenus = result
                    self?.currentMenuBinder.onNext(result)
                }
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

private extension Array {
    mutating func shuffleAndRemove() -> Self {
        self.shuffle()
        self.removeSubrange(0...self.count/((2...5).randomElement() ?? 2))
        return self
    }
}
