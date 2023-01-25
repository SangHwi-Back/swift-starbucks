//
//  StarbucksItemDTO.swift
//  BeckBucks
//
//  Created by 백상휘 on 2022/09/27.
//

import Foundation

struct StarbucksArray: Decodable {
  let foods: [StarbucksItemDTO]
}

protocol StarbucksEntity {
    var fileName: String { get }
    var imageData: Data? { get set }
}

struct StarbucksItemDTO: Decodable, Identifiable, StarbucksEntity {
  
  enum CodingKeys: CodingKey {
    case key, fileName, title, subTitle, engTitle, menuDescription, menuPrice, tempOption, menuNotification, nutritionInfo, allergy, badge
  }
  
  enum TemperatureOptions: Int, Decodable {
    case hot = 0
    case cold = 1
  }
  
  enum SizeCategory: Int, Decodable {
    case Short = 0
    case Tall = 1
    case Grande = 2
    case Venti = 3
  }
  
  enum AllergyElement: Int, Decodable {
    case milk = 0
    case bean = 1
    case wheat = 2
    case egg = 3
    case pig = 4
    case dioxideSulfurousAcid = 5
    case tomato = 6
    case clam = 7
    case cow = 8
  }
  
  enum NotifyBadge: Int, Decodable {
    case best = 0
    case new = 1
    case hot = 2
    case reserve = 3
  }
  
  let id: String
  /// image file name
  let fileName: String
  /// 메뉴 제목
  let title: String
  /// 메뉴 부제목
  let subTitle: String?
  /// 메뉴 영어이름
  let engTitle: String
  /// 메뉴 설명
  let menuDescription: String
  /// 메뉴 최소가격
  let menuPrice: Float
  /// 따뜻한/시원한 음료 여부
  var tempOption: TemperatureOptions?
  /// 메뉴 알림설명
  let menuNotification: String?
  /// 메뉴 영양정보
  let nutritionInfo: [NutritionInfo]
  /// 알러지 유발 요인(@로 구분)
  let allergy: [AllergyElement]
  let badge: NotifyBadge?
  
  // no Data from json
  var imageData: Data?
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try container.decode(String.self, forKey: .key)
    self.fileName = try container.decode(String.self, forKey: .fileName)
    self.title = try container.decode(String.self, forKey: .title)
    self.subTitle = try? container.decode(String.self, forKey: .subTitle)
    self.engTitle = try container.decode(String.self, forKey: .engTitle)
    self.menuDescription = try container.decode(String.self, forKey: .menuDescription)
    self.menuPrice = try container.decode(Float.self, forKey: .menuPrice)
    self.tempOption = try? container.decode(TemperatureOptions.self, forKey: .tempOption)
    self.menuNotification = try? container.decode(String.self, forKey: .menuNotification)
    self.nutritionInfo = try container.decode([NutritionInfo].self, forKey: .nutritionInfo)
    self.allergy = try container.decode([AllergyElement].self, forKey: .allergy)
    self.badge = try? container.decode(NotifyBadge.self, forKey: .badge)
  }
}

struct NutritionInfo: Decodable {
  let category: StarbucksItemDTO.SizeCategory? // 0: Short, 1: Tall, 2: Grande, 3: Venti
  /// 용량정보
  let volume: String
  /// 칼로리(단위 k)
  let kcal: Float
  /// 탄수화물(단위 gram)
  let carbonG: Float
  /// 당류(단위 gram)
  let sugarG: Float
  /// 나트륨(단위 miligram)
  let sodiumMG: Float
  /// 단백질(단위 gram)
  let proteinG: Float
  /// 지방(단위 gram)
  let fatG: Float
  /// 콜레스테롤(단위 miligram)
  let cholesterolMG: Float
  /// 트랜스 지방(단위 gram)
  let transFatG: Float
  /// 포화 지방(단위 gram)
  let satFatG: Float
  /// 카페인(단위 miligram)
  let caffeineMG: Float
  
  enum CodingKeys: CodingKey {
    case category, volume, kcal, carbonG, sugarG, sodiumMG, proteinG, fatG, cholesterolMG, transFatG, satFatG, caffeineMG
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.category = try? container.decodeIfPresent(StarbucksItemDTO.SizeCategory.self, forKey: .category)
    self.volume = try container.decode(String.self, forKey: .volume)
    self.kcal = try container.decode(Float.self, forKey: .kcal)
    self.carbonG = try container.decode(Float.self, forKey: .carbonG)
    self.sugarG = try container.decode(Float.self, forKey: .sugarG)
    self.sodiumMG = try container.decode(Float.self, forKey: .sodiumMG)
    self.proteinG = try container.decode(Float.self, forKey: .proteinG)
    self.fatG = try container.decode(Float.self, forKey: .fatG)
    self.cholesterolMG = try container.decode(Float.self, forKey: .cholesterolMG)
    self.transFatG = try container.decode(Float.self, forKey: .transFatG)
    self.satFatG = try container.decode(Float.self, forKey: .satFatG)
    self.caffeineMG = try container.decode(Float.self, forKey: .caffeineMG)
  }
}
