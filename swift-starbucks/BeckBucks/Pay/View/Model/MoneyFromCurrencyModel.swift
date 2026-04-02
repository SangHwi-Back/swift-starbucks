//
//  MoneyFromCurrencyModel.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/02/14.
//

import Foundation
import RxSwift

/// United States = en-US
/// Republic of Korea = ko-KR
/// Japan = ja-JP
/// India = bn-IN
///
/// 달러 = 1267.3원
/// 루피 = 15.3원
/// 엔화 = 9.5원
class MoneyFromCurrencyModel: JSONFetchable {
    private var disposeBag = DisposeBag()
    
    var jsonName: String?
    var rates: [ExchangeRate] = []
    
    let locale: Locale
    let currencyCode: String?
    
    private var priceNumberFormatter: NumberFormatter = {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.roundingMode = .down
        formatter.allowsFloats = false
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.currencySymbol = ""
        return formatter
    }()
    
    init(currencyCode: String) {
        self.locale = Locale(identifier: currencyCode)
        self.currencyCode = currencyCode
        self.jsonName = "exchangeRate"
    }
    
    func getDefinedChargeAmounts() -> [Int] {
        guard
            let currencyCode,
            let rate = rates.first(where: { $0.currencyCode == currencyCode})
        else {
            return []
        }
        
        return rate.definedChargeValues
    }
    
    func getDefinedChargeStrings(_ formatter: NumberFormatter? = nil) -> [String] {
        getDefinedChargeAmounts().compactMap { value -> String? in
            
            let amount = NSNumber(floatLiteral: Double(value))
            return self.priceNumberFormatter.string(from: amount)
        }
    }
    
    func getCurrencySymbol() -> String? {
        return locale.currencySymbol
    }
}

struct ExchangeRateWrapper: Decodable {
    let rates: [ExchangeRate]
}

struct ExchangeRate: Decodable {
    let currencyCode: String
    let valueFromWon: Float
    let definedChargeValues: [Int]
    let currencySymbol: String?
}
