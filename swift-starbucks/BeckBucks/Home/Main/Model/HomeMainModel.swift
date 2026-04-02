//
//  HomeMainModel.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/04/06.
//

import Foundation
import RxSwift
import RxCocoa

class HomeMainModel<RESPONSE: Decodable, RESULT>: JSONFetchable {
    let itemBinder = BehaviorRelay<[RESULT]>(value: [])
    
    private var disposeBag = DisposeBag()
    var jsonName: String?
    var decodingHandler: ((Data) throws ->[RESULT])?
    
    init(jsonName: String, decodingHandler: @escaping ((Data) throws -> [RESULT])) {
        self.jsonName = jsonName
        self.decodingHandler = decodingHandler
    }
    
    func fetch() {
        getJSONFetchObservable()
            .subscribe(onNext: { [weak self] result in
                if let error = result.response.getRequestError {
                    print(error)
                    return
                }
                
                do {
                    let result = try self?.decodingHandler?(result.data) ?? []
                    self?.itemBinder.accept(result)
                } catch {
                    print(error)
                }
            })
            .disposed(by: disposeBag)
    }
}
