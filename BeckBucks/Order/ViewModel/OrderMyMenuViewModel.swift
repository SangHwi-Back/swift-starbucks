//
//  OrderMyMenuViewModel.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/20.
//

import Foundation
import RxSwift
import RxCocoa

class OrderMyMenuViewModel: StarbucksViewModel<StarbucksItemDTO> {
    func resetItems() {
        self.items.removeAll()
        fetchJSON(name: "drink")
    }
}
