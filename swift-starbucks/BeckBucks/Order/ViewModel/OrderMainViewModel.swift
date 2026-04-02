//
//  OrderMainViewModel.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/26.
//

import Foundation
import RxSwift
import RxCocoa

class OrderMainViewModel: StarbucksViewModel<StarbucksItemDTO>, ImageFetchable, JSONFetchable {
    
    var imageData: [String : Data] = [:]
    var jsonName: String?
    
    convenience init(jsonName: String) {
        self.init()
        self.jsonName = jsonName
    }
    
    func getImage(at rowNum: Int) -> Observable<Data> {
        guard rowNum < items.count else {
            return .error(ViewModelError.indexOutOfRange("indexOutOfRange: rowNumber a.k.a index (\(rowNum)), itemsCount (\(items.count))"))
        }
        
        let fileName = items[rowNum].fileName
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
                    self.items = (try JSONDecoder().decode(StarbucksArray.self, from: result.data)).foods
                    self.itemBinder.onNext(self.items)
                } catch {
                    self.itemBinder.onError(error)
                }
            })
            .disposed(by: disposeBag)
    }
}
