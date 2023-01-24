//
//  HallCakeReservationViewModel.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/13.
//

import Foundation
import RxCocoa
import RxSwift

class HallCakeReservationViewModel {
    
    private var items = [HallCakeItemEntity]() {
        didSet {
            itemsBinder.accept(items)
        }
    }
    let itemsBinder = PublishRelay<[HallCakeItemEntity]>()
    
    var disposeBag = DisposeBag()
    
    init() {
        URLProtocol.registerClass(HTTPRequestMockProtocol.self)
    }
    
    deinit {
        URLProtocol.unregisterClass(HTTPRequestMockProtocol.self)
    }
    
    func resolveUI() {
        guard let url = Bundle.main.url(forResource: "hallCake", withExtension: "json") else { return }
        
        URLSession.shared.rx
            .response(request: URLRequest(url: url))
            .subscribe { (response: HTTPURLResponse, data: Data) in
                guard let result = try? JSONDecoder().decode(HallCakeResponse.self, from: data) else {
                    return
                }
                
                self.items = result.list
            }
            .disposed(by: disposeBag)
    }
}

private struct HallCakeResponse: Decodable {
    let list: [HallCakeItemEntity]
}

struct HallCakeItemEntity: Decodable {
    let title: String
    let engTitle: String
    let imageData: Data
    let price: Int
    
    enum CodingKeys: CodingKey {
        case title
        case engTitle
        case imageName
        case price
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.engTitle = try container.decode(String.self, forKey: .engTitle)
        
        if
            let imageName = try? container.decode(String.self, forKey: .imageName),
            let url = Bundle.main.url(forResource: imageName, withExtension: "jpg"),
            let data = try? Data(contentsOf: url)
        {
            self.imageData = data
        } else {
            self.imageData = Data()
        }
        
        self.price = try container.decode(Int.self, forKey: .price)
    }
}
