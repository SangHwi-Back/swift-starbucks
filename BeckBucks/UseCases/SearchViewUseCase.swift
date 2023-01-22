//
//  SearchViewUseCase.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/22.
//

import Foundation
import RxSwift
import RxCocoa

class SearchViewUseCase<OutputType> {
    
    private(set) var searchHistory: [String] = []
    var disposeBag = DisposeBag()
    
    init(_ histories: [String]) {
        self.searchHistory = histories
    }
    
    func removeAllHistories() {
        self.searchHistory.removeAll()
    }
    
    func removeHistory(at index: Int) {
        self.searchHistory.remove(at: index)
    }
}
