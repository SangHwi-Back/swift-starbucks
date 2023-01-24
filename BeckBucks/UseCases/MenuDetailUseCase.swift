//
//  MenuDetailUseCase.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/23.
//

import Foundation
import RxSwift
import RxCocoa

class MenuDetailUseCase {
    let formatter = NumberFormatter()
    let entity: StarbucksItemDTO
    let recommendationsRelay = BehaviorRelay<[StarbucksItemDTO]>(value: [])
    private var recommendations: [StarbucksItemDTO] = [] {
        didSet {
            recommendationsRelay.accept(recommendations)
        }
    }
    private let tempOptionSubject = PublishSubject<StarbucksItemDTO.TemperatureOptions?>()
    
    private var disposeBag = DisposeBag()
    
    init(entity: StarbucksItemDTO) {
        URLProtocol.registerClass(HTTPRequestMockProtocol.self)
        formatter.numberStyle = .decimal
        self.entity = entity
    }
    
    deinit {
        URLProtocol.unregisterClass(HTTPRequestMockProtocol.self)
    }
    
    func getPrice(from price: Float) -> String {
        return (formatter.string(from: NSNumber(value: price)) ?? "") + "원"
    }
    
    func getRecommendations() {
        guard let url = Bundle.main.url(forResource: "drink", withExtension: "json") else {
            return
        }
        
        URLSession.shared.rx
            .response(request: URLRequest(url: url))
            .subscribe(onNext: { [weak self] response in
                guard let result = try? JSONDecoder().decode(StarbucksArray.self, from: response.data) else {
                    return
                }
                
                self?.recommendations.append(contentsOf: result.foods)
            })
            .disposed(by: disposeBag)
    }
    
    func getRecommendationImage(at index: Int) -> Observable<Data?> {
        guard index < recommendations.count else {
            return .empty()
        }
        
        return recommendations[index].name
            .toFetchJPEGObservable()
    }
}
