//
//  String+Extensions.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/24.
//

import Foundation
import RxSwift

extension String {
    func toFetchJPEGObservable() -> Observable<Data?> {
        let jpgURL = Bundle.main.url(forResource: self, withExtension: "jpg")
        let jpegURL = Bundle.main.url(forResource: self, withExtension: "jpeg")
        
        var url: URL? = jpgURL ?? jpegURL
        
        guard let url = url else { return .empty() }
        
        return URLSession.shared.rx
            .response(request: URLRequest(url: url))
            .map({ $0.data })
    }
}
