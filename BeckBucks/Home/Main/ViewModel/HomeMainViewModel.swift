import RxSwift
import RxCocoa
import Foundation

class HomeMainViewModel: JSONFetchable {
    private(set) var mainEntity: HomeMainDTO?
    let itemBinder = PublishSubject<HomeMainDTO>()
    
    var jsonName: String?
    var disposeBag = DisposeBag()
    
    init() {
        jsonName = "homeMainData"
    }
    
    func fetch() {
        getJSONFetchObservable()
            .subscribe(onNext: { [weak self] result in
                if let error = result.response.getRequestError {
                    self?.itemBinder.onError(error)
                    return
                }
                
                do {
                    let entity = (try JSONDecoder().decode(HomeMainDTO.self, from: result.data))
                    self?.mainEntity = entity
                    self?.itemBinder.onNext(entity)
                } catch {
                    self?.itemBinder.onError(error)
                }
            })
            .disposed(by: disposeBag)
    }
}
