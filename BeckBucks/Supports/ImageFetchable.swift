//
//  ImageFetchable.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/26.
//

import Foundation
import RxSwift

protocol ImageFetchable {
    var imageData: [String: Data] { get set }
}

extension ImageFetchable {
    func getImageFrom(fileName: String) -> Observable<Data> {
        if let data = imageData[fileName] {
            return .just(data)
        }
        
        guard let url = fileName.getImageURL() else {
            return .just(Data())
            // TODO: - card_seattle.png URL Not found error occured. reason unknown.
//            return .error(ViewModelError.urlError("fileName : \(fileName)"))
        }
        
        return URLSession.shared.rx.data(request: URLRequest(url: url))
    }
}

extension String {
    func getImageURL() -> URL? {
        Bundle.main.url(forResource: self, withExtension: "jpeg")
        ?? Bundle.main.url(forResource: self, withExtension: "jpg")
        ?? Bundle.main.url(forResource: self, withExtension: "png")
    }
}
