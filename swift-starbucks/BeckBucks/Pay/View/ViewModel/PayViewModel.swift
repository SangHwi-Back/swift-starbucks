//
//  PayViewModel.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/02/03.
//

import Foundation
import RxSwift
import RxCocoa

class PayViewModel: StarbucksViewModel<CardInformation>, ImageFetchable, JSONFetchable {
    typealias Entity = CardInformation
    
    var jsonName: String?
    var imageData: [String : Data] = [:]
    
    var updateEntitySubject = PublishSubject<Entity>()
    
    override var items: [StarbucksViewModel<CardInformation>.Entity] {
        didSet {
            itemBinder.onNext(items)
        }
    }
    
    init(jsonName: String?) {
        super.init()
        self.jsonName = jsonName
        updateEntitySubject
            .subscribe(onNext: { [weak self] entity in
                self?.updateItem(entity)
            })
            .disposed(by: disposeBag)
    }
    
    subscript(index: Int) -> Entity? {
        guard 0..<items.count ~= index else {
            return nil
        }
        
        return items[index]
    }
    
    func getImage(at rowNum: Int) -> Observable<Data> {
        guard rowNum < items.count else {
            return .error(ViewModelError.indexOutOfRange("indexOutOfRange: rowNumber a.k.a index (\(rowNum)), itemsCount (\(items.count))"))
        }
        
        let fileName = items[rowNum].card_name
        let imageObservable: Observable<Data> = getImageFrom(fileName: fileName)
        
        return imageObservable
            .do(onNext: { [weak self] data in
                guard let self = self else { return }
                self.imageData[fileName] = data
            })
    }
    
    func fetch() {
        getJSONFetchObservable()
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                
                if let error = result.response.getRequestError {
                    self.itemBinder.onError(error)
                    return
                }
                
                do {
                    self.items = (try JSONDecoder().decode(StarbucksCardArray.self, from: result.data)).cards
                    self.itemBinder.onNext(self.items)
                } catch {
                    self.itemBinder.onError(error)
                }
            })
            .disposed(by: disposeBag)
    }
}

struct StarbucksCardArray: Decodable {
    var cards: [CardInformation]
}

struct CardInformation: Equatable, Identifiable, Decodable {
    let id: Int
    let name: String
    var balance: Float
    let currency: String
    let card_name: String
    let card_number: String
    let isUsing: Bool
}
