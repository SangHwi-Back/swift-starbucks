//
//  CommonViewModel.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/25.
//

import Foundation
import RxCocoa
import RxSwift

class StarbucksViewModel<EntityType>: ViewModel where EntityType: Identifiable, EntityType: Equatable {
    typealias Entity = EntityType
    
    var items: [Entity] = []
    
    var disposeBag = DisposeBag()
    let itemBinder = PublishSubject<[Entity]>()
    
    init() {
        URLProtocol.registerClass(HTTPRequestMockProtocol.self)
    }
    
    deinit {
        URLProtocol.unregisterClass(HTTPRequestMockProtocol.self)
    }
}

extension StarbucksViewModel where Entity: Identifiable, Entity: Equatable {
    func getItem(at index: Int) -> Entity? {
        if index < items.count-1 {
            return items[index]
        }
        
        return nil
    }
    
    func getItem(id: Entity.ID) -> Entity? {
        guard let index = items.firstIndex(where: { $0.id == id }) else {
            return nil
        }
        
        return items[index]
    }
    
    @discardableResult
    func removeItem(at index: Int) -> Entity? {
        if index < items.count-1 {
            items.remove(at: index)
        }
        
        return nil
    }
    
    @discardableResult
    func removeItem(id: Entity.ID) -> Entity? {
        guard let index = items.firstIndex(where: { $0.id == id }) else {
            return nil
        }
        
        return items.remove(at: index)
    }
    
    @discardableResult
    func removeItem(_ entity: Entity) -> Entity? {
        guard let index = items.firstIndex(where: { $0.id == entity.id }) else {
            return nil
        }
        
        return items.remove(at: index)
    }
    
    @discardableResult
    func updateItem(_ entity: Entity) -> Entity? {
        guard let index = items.firstIndex(where: { $0.id == entity.id }) else {
            return nil
        }
        
        items[index] = entity
        
        return items[index]
    }
    
    func count() -> Int {
        items.count
    }
}
