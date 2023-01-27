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
    func getImageFrom(fileName: String, at index: Int) -> Observable<Data> {
        if let data = imageData[fileName] {
            return .just(data)
        }
        
        let jpegURL = Bundle.main.url(forResource: fileName, withExtension: "jpeg")
        let jpgURL = Bundle.main.url(forResource: fileName, withExtension: "jpg")
        
        guard let url = jpegURL ?? jpgURL else {
            return .error(ViewModelError.urlError("fileName : \(fileName)"))
        }
        
        return URLSession.shared.rx.data(request: URLRequest(url: url))
    }
}