//
//  JSONFetchable.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/26.
//

import Foundation
import RxSwift

protocol JSONFetchable {
    var jsonName: String? { get set }
}

extension JSONFetchable {
    func getJSONFetchObservable() -> Observable<(response: HTTPURLResponse, data: Data)> {
        guard let jsonName else {
            return .error(ViewModelError.errorWithMessage("JSON File Name not defined."))
        }
        guard let url = Bundle.main.url(forResource: jsonName, withExtension: "json") else {
            return .error(ViewModelError.urlError("JSON URL doesn't created using jsonname \(jsonName)."))
        }
        
        return URLSession.shared.rx
            .response(request: URLRequest(url: url))
    }
}
