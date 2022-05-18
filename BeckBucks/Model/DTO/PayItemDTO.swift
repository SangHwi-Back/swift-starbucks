import Foundation

struct PayItemDTO: Codable {
  let view: PayItemView
}

struct PayItemView: Codable {
  let product_NM: String
  let product_ENGNM: String
  let content: String
  let kcal: String // 칼로리
  let fat: String // 지방
  let price: String // 가격
  let hot_YN: String // Hot/Iced 여부
  let standard: String // 용량 값
  let unit: String // 용량 단위
  let sat_FAT: String // 포화 지방
  let trans_FAT: String // 트랜스 지방
  let cholesterol: String // 콜레스테롤
  let sugars: String // 당류
  let chabo: String // 탄수화물
  let protein: String // 단백질
  let sodium: String // 나트륨
  let caffeine: String // 카페인
  let allergy: String // 알러지 유발 요인(@로 구분)
}
