//
//  PayViewModel.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/02/03.
//

import Foundation
import RxSwift
import RxCocoa

class PayViewModel: StarbucksViewModel<CardInformation> {
    typealias Entity = CardInformation
}

struct CardInformation: Equatable, Identifiable, Decodable {
    let id: Int
    let name: String
    let balance: Float
    let currency: String
    let card_name: String
    let card_number: String
    let isUsing: Bool
}
