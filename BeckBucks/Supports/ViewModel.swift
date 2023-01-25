//
//  OrderUseCase.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/20.
//

import Foundation
import RxCocoa
import RxSwift

enum ViewModelError: Error {
    case testError
    case indexOutOfRange(String)
    case urlError(String)
    case decodeFailed(String)
    case requestError(Int)
    case errorWithMessage(String)
}

protocol ViewModel {
    associatedtype Entity
    
    var items: [Entity] { get }
    
    var disposeBag: DisposeBag { get set }
    var itemBinder: PublishSubject<[Entity]> { get }
    
    func getImageFrom(rowNumber index: Int) -> Observable<Data>
    
    func getItem(at index: Int) -> Entity?
}

extension ViewModel {
    
    func getItem(at index: Int) -> Entity? {
        guard index < items.count-1 else {
            return nil
        }
        
        return items[index]
    }
}
