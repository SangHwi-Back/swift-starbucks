//
//  OrderFoodMenuViewModel.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/09.
//

import Foundation
import RxCocoa
import RxSwift

class OrderFoodMenuViewModel: StarbucksViewModel<StarbucksItemDTO> {
    func resetItems() {
        self.items.removeAll()
        fetchJSON(name: "food")
    }
}
