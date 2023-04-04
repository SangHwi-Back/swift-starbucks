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
    let foodModel = HomeMainModel<StarbucksArray, MainItemDTO>(jsonName: "food") {
        let decoded = try JSONDecoder().decode(StarbucksArray.self, from: $0).foods
        return decoded.map {
            MainItemDTO(
                title: $0.title,
                subTitle: $0.subTitle,
                description: $0.menuDescription,
                fileName: $0.fileName,
                imageData: $0.imageData)
        }
    }
    let drinkModel = HomeMainModel<StarbucksArray, MainItemDTO>(jsonName: "drink") {
        let decoded = try JSONDecoder().decode(StarbucksArray.self, from: $0).foods
        return decoded.map {
            MainItemDTO(
                title: $0.title,
                subTitle: $0.subTitle,
                description: $0.menuDescription,
                fileName: $0.fileName)
        }
    }
    let mainDataModel = HomeMainModel<HomeMainDTO, MainItemDTO>(jsonName: "homeMainData") {
        let decoded = try JSONDecoder().decode(HomeMainDTO.self, from: $0)
        return decoded.whatsNewList.map {
            MainItemDTO(
                title: $0.title,
                subTitle: $0.subTitle,
                description: "",
                fileName: $0.imageFileName,
                detailFileName: $0.detailImageFileName)
        }
    }
    
    @HomeMainIndex(wrappedValue: 0, 2) var currentIndex {
        didSet{
            indexSubject.onNext(currentViewModelBinder)
        }
    }
    var indexSubject = PublishSubject<BehaviorSubject<[MainItemDTO]>>()
    
    init() {
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
    
}

// MARK: - View Indexes
extension HomeViewModel {
    var currentViewModelBinder: BehaviorSubject<[MainItemDTO]> {
        if currentIndex == 0 {
            return foodModel.itemBinder
        }
        else if currentIndex == 1 {
            return drinkModel.itemBinder
        }
        else {
            return mainDataModel.itemBinder
        }
    }
}

// MARK: - View Entities
//extension HomeViewModel {
    struct MainItemDTO: Decodable, StarbucksEntity {
        var title: String
        var subTitle: String?
        var description: String
        var fileName: String
        var detailFileName: String?
        var imageData: Data?
    }
//}

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



class HomeMainModel<RESPONSE: Decodable, RESULT>: JSONFetchable {
    let itemBinder = BehaviorSubject<[RESULT]>(value: [])
    
    private var disposeBag = DisposeBag()
    var jsonName: String?
    var decodingHandler: ((Data) throws ->[RESULT])?
    
    
    init(jsonName: String, decodingHandler: @escaping ((Data) throws -> [RESULT])) {
        self.jsonName = jsonName
        self.decodingHandler = decodingHandler
    }
    
    func fetch() {
        getJSONFetchObservable()
            .subscribe(onNext: { [weak self] result in
                if let error = result.response.getRequestError {
                    self?.itemBinder.onError(error)
                    return
                }
                
                do {
                    let result = try self?.decodingHandler?(result.data) ?? []
                    self?.itemBinder.onNext(result)
                } catch {
                    self?.itemBinder.onError(error)
                }
            })
            .disposed(by: disposeBag)
    }
}
