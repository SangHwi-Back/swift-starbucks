//
//  OrderAllMenuUseCase.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/09.
//

import Foundation
import RxCocoa
import RxSwift

class OrderAllMenuUseCase {
    
    var disposeBag = DisposeBag()
    
    let itemBinder = PublishRelay<[StarbucksItemDTO]>()
    let selectedMenuBinder = PublishRelay<SelectedMenuButton>()
    
    init() {
        URLProtocol.registerClass(HTTPRequestMockProtocol.self)
    }
    
    deinit {
        URLProtocol.unregisterClass(HTTPRequestMockProtocol.self)
    }
    
    private var items: [StarbucksItemDTO] {
        switch selectedMenuButton {
        case .beverage:
            return drinkItems
        case .food:
            return foodItems
        }
    }
    
    private var drinkItems = [StarbucksItemDTO]()
    private var foodItems = [StarbucksItemDTO]()
    
    private var selectedMenuButton: SelectedMenuButton = .beverage {
        didSet {
            resolveItems(from: selectedMenuButton)
            selectedMenuBinder.accept(selectedMenuButton)
        }
    }
    
    func resetItems() {
        drinkItems.removeAll()
        foodItems.removeAll()
    }
    
    func bindRequestedImage(rowNumber: Int) -> Observable<UIImage?> {
        guard
            0..<items.count ~= rowNumber,
            let url = Bundle.main.url(forResource: items[rowNumber].name,
                                      withExtension: "jpg")
        else {
            return .empty()
        }
        
        return URLSession.shared.rx
            .response(request: URLRequest(url: url))
            .map({ UIImage(data: $0.data) })
    }
    
    func getItemTitle(rowNumber: Int) -> String? {
        guard 0..<items.count ~= rowNumber else {
            return nil
        }
        
        return items[rowNumber].title
    }
    
    func resolveItems(from selectedButton: SelectedMenuButton) {
        
        let currentItems = (selectedButton == .beverage ? drinkItems : foodItems)
        
        guard currentItems.isEmpty else {
            itemBinder.accept(items)
            return
        }
        
        let url = Bundle.main.url(forResource: selectedButton.getJSONName(),
                                  withExtension: "json")
        
        getFoodImageDataTitled(title: selectedButton.getJSONName(), jsonURL: url)
            .subscribe(onNext: { [weak self] entities in
                switch selectedButton {
                case .beverage: self?.drinkItems = entities
                case .food: self?.foodItems = entities
                }
                
                self?.itemBinder.accept(self?.items ?? [])
            })
            .disposed(by: disposeBag)
    }
    
    private func getFoodImageDataTitled(title: String, jsonURL: URL?) -> Observable<[StarbucksItemDTO]> {
        guard let jsonURL else {
            return Observable.error(UseCaseError.urlError(jsonURL.getErrorMessage))
        }
        
        return URLSession.shared.rx.response(request: URLRequest(url: jsonURL))
            .map({ result -> [StarbucksItemDTO] in
                if let error = result.response.getRequestError {
                    throw error
                }
                
                guard let result = try? JSONDecoder().decode(StarbucksArray.self, from: result.data) else {
                    throw UseCaseError.decodeFailed(result.response.url.getErrorMessage)
                }
                
                return result.foods
            })
    }
    
    func setSelectedMenuButton(_ selected: SelectedMenuButton) {
        selectedMenuButton = selected
    }
    
    enum SelectedMenuButton {
        case beverage
        case food
        
        func getJSONName() -> String {
            switch self {
            case .beverage: return "drink"
            case .food: return "food"
            }
        }
    }
}

private extension HTTPURLResponse {
    var getRequestError: Error? {
        guard self.isSuccess else {
            return UseCaseError.requestError(self.statusCode)
        }
        
        return nil
    }
}

private extension Optional where Wrapped == URL {
    var getErrorMessage: String {
        ("Error occured at " + (self?.absoluteString ?? "unkown URL") + ".")
    }
}

