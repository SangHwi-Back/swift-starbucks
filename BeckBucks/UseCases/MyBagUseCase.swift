//
//  MyBagUseCase.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/15.
//

import Foundation
import RxSwift
import RxCocoa

class MyBagUseCase {
    
    private(set) var foodItems: [MyBagFoodData] = []
    let foodBinder: PublishRelay<[MyBagFoodData]> = .init()
    
    private(set) var merchItems: [MyBagMerchandiseData] = []
    let merchBinder: PublishRelay<[MyBagMerchandiseData]> = .init()
    
    var disposeBag = DisposeBag()
    
    convenience init(_ isTest: Bool) {
        self.init()
        
        if isTest {
            
            foodItems = MyBagFoodData.getTestData()
            merchItems = MyBagMerchandiseData.getTestData()
        }
    }
    
    func getFoodItem(_ index: Int) -> MyBagFoodData? {
        guard 0..<foodItems.count ~= index else {
            return nil
        }
        
        return foodItems[index]
    }
    
    func getMerchandiseItem(_ index: Int) -> MyBagMerchandiseData? {
        guard 0..<merchItems.count ~= index else {
            return nil
        }
        
        return merchItems[index]
    }
}

protocol MyBagData {
    var title: String { get }
    var engTitle: String { get }
    var description: String { get }
}

struct MyBagEntity {
    var entity: [any MyBagData]
}

struct MyBagFoodData: MyBagData {
    let title: String
    let engTitle: String
    let description: String
    
    let pricePerUnit: Float
    
    static func getTestData() -> [Self] {
        return [
            MyBagFoodData(title: "치즈 포크 커틀릿 샌드위치", engTitle: "Cheese Pork Cutlet Sandwich", description: "치즈 포크 커틀릿 샌드위치", pricePerUnit: 6200),
            MyBagFoodData(title: "V.L.T. 샌드위치", engTitle: "V.L.T. Sandwich", description: "V.L.T. 샌드위치", pricePerUnit: 7700),
        ]
    }
}

struct MyBagMerchandiseData: MyBagData {
    let title: String
    let engTitle: String
    let description: String
    
    let pricePerUnit: Float
    var unitOption: [any FoodOptions] = []
    
    static func getTestData() -> [Self] {
        return [
            MyBagMerchandiseData(title: "화이트 사이렌 커피 클립 스쿱", engTitle: "White siren coffee clip scoop", description: "화이트 사이렌 커피 클립 스쿱", pricePerUnit: 14000),
            MyBagMerchandiseData(title: "사이렌 고케틀", engTitle: "Siren go-kettle", description: "사이렌 고케틀", pricePerUnit: 16000),
        ]
    }
}

protocol FoodOptions {
    func getName() -> String
}

enum FoodiseWarmingOptions: FoodOptions {
    case warm
    case cold
    case none
    
    func getName() -> String {
        switch self {
        case .warm: return "따뜻하게 데움"
        case .cold: return "차갑게 식힘"
        case .none: return "데우지 않음"
        }
    }
}

enum FoodSideMenuOptions: FoodOptions {
    case lurpakButter
    case wooriBerryJam
    case creamCheese
    
    func getName() -> String {
        switch self {
        case .lurpakButter: return "루어팍 버터"
        case .wooriBerryJam: return "우리 베리 잼"
        case .creamCheese: return "크림 치즈"
        }
    }
}
