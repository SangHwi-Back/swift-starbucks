//
//  CommonViewModel.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/25.
//

import Foundation
import RxCocoa
import RxSwift

class StarbucksViewModel<EntityType>: ViewModel where EntityType: StarbucksEntity {
    
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
    
    func getImageFrom(rowNumber index: Int) -> Observable<Data> {
        guard index < items.count else {
            return .error(ViewModelError.indexOutOfRange("indexOutOfRange: rowNumber a.k.a index (\(index)), itemsCount (\(items.count))"))
        }
        
        if let data = items[index].imageData {
            return .just(data)
        }
        
        let jpegURL = Bundle.main.url(forResource: items[index].fileName, withExtension: "jpeg")
        let jpgURL = Bundle.main.url(forResource: items[index].fileName, withExtension: "jpg")
        
        guard let url = jpegURL ?? jpgURL else {
            return .error(ViewModelError.urlError("fileName : \(items[index].fileName)"))
        }
        
        return URLSession.shared.rx.data(request: URLRequest(url: url))
            .do(onNext:{ [weak self] in self?.items[index].imageData = $0 })
    }
}

extension StarbucksViewModel where EntityType == StarbucksItemDTO {
    func fetchJSON(name fileName: String) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            return
        }
        
        URLSession.shared.rx
            .response(request: URLRequest(url: url))
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

extension Optional where Wrapped == URL {
    var getErrorMessage: String {
        ("Error occured at " + (self?.absoluteString ?? "unkown URL") + ".")
    }
}

extension HTTPURLResponse {
    var getRequestError: Error? {
        guard self.isSuccess else {
            return ViewModelError.requestError(self.statusCode)
        }
        
        return nil
    }
}

