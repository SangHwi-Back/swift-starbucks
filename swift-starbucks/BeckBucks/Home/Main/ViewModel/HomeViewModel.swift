//
//  HomeViewModel.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/04/03.
//

import Foundation
import RxSwift
import RxCocoa

class HomeViewModel: ReactiveCompatible {
    typealias DTO = MainItemDTO
    let foodModel = HomeMainModel<StarbucksArray, MainItemDTO>(jsonName: "food") {
        try JSONDecoder().decode(StarbucksArray.self, from: $0)
            .foods
            .map {
                MainItemDTO(
                    title: $0.title,
                    subTitle: $0.subTitle,
                    description: $0.menuDescription,
                    fileName: $0.fileName,
                    imageData: $0.imageData)
            }
    }
    let drinkModel = HomeMainModel<StarbucksArray, MainItemDTO>(jsonName: "drink") {
        try JSONDecoder().decode(StarbucksArray.self, from: $0)
            .foods
            .map {
                MainItemDTO(
                    title: $0.title,
                    subTitle: $0.subTitle,
                    description: $0.menuDescription,
                    fileName: $0.fileName)
            }
    }
    let mainDataModel = HomeMainModel<HomeMainDTO, MainItemDTO>(jsonName: "homeMainData") {
        try JSONDecoder().decode(HomeMainDTO.self, from: $0)
            .whatsNewList
            .map {
                MainItemDTO(
                    title: $0.title,
                    subTitle: $0.subTitle,
                    description: "",
                    fileName: $0.imageFileName,
                    detailFileName: $0.detailImageFileName)
            }
    }
    
    /// Emit itemBinder when currentIndex Changed.
    ///
    /// Set **currentIndex** -> **relayByIndex** acceps Optional<itemBinderl> -> **Optional<itemBinder>** contains food or drink or mainData.
    fileprivate var relayByIndex = PublishRelay<BehaviorRelay<[MainItemDTO]>?>()
    @HomeMainIndex(wrappedValue: 0, 2) var currentIndex {
        didSet{
            relayByIndex.accept(currentViewModelBinder)
        }
    }
    
    init() {
        fetchAll()
    }
    
    func fetchAll() {
        foodModel.fetch()
        drinkModel.fetch()
        mainDataModel.fetch()
    }
}

extension Reactive where Base: HomeViewModel {
    var indexBindable: Binder<Int> {
        Binder(base) { base, value in
            base.currentIndex = value
        }
    }
    /// Emit nil when wrong index is set.
    var itemBinderByIndex: ControlEvent<BehaviorRelay<[HomeViewModel.MainItemDTO]>?> {
        ControlEvent(events: base.relayByIndex)
    }
}

// MARK: - View Indexes
extension HomeViewModel {
    var currentViewModelBinder: BehaviorRelay<[MainItemDTO]>? {
        switch currentIndex {
        case 0: return foodModel.itemBinder
        case 1: return drinkModel.itemBinder
        case 2: return mainDataModel.itemBinder
        default: return nil
        }
    }
}

// MARK: - View Entities
extension HomeViewModel {
    struct MainItemDTO: Decodable, StarbucksEntity {
        var title: String
        var subTitle: String?
        var description: String
        var fileName: String
        var detailFileName: String?
        var imageData: Data?
    }
    
    @propertyWrapper
    private struct HomeMainIndex {
        var index = 0
        let max: Int
        init(wrappedValue initialValue: Int, _ max: Int) {
            self.index = initialValue
            self.max = max
        }
        
        var wrappedValue: Int {
            get {
                self.index
            }
            set {
                if 0...max ~= newValue {
                    self.index = newValue
                }
            }
        }
    }
}
