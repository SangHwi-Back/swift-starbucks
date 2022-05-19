import Foundation
import UIKit
import RxSwift

class ContentsViewController: UIViewController {
  
  @IBOutlet weak var mainScrollView: UIScrollView!
  
  @IBOutlet weak var nameLabel: UILabel!
  
  @IBOutlet weak var recommendScrollView: UIScrollView!
  @IBOutlet weak var recommendStackView: UIStackView!
  @IBOutlet weak var recommendItemStackView: UIStackView!
  
  @IBOutlet weak var mainEventImageView: UIImageView!
  @IBOutlet weak var mainEventImageViewHeightConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var seeAllButton: UIButton!
  
  @IBOutlet weak var ingListScrollView: UIScrollView!
  @IBOutlet weak var ingListStackView: UIStackView!
  @IBOutlet weak var ingListItemStackView: UIStackView!
  
  @IBOutlet weak var thisTimeRecommendScrollView: UIScrollView!
  @IBOutlet weak var thisTimeRecommendStackView: UIStackView!
  @IBOutlet weak var thisTimeRecommendItemStackView: UIStackView!
  
  let useCase = HomeMainUseCase()
  let bag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    useCase.getMainInfo()
      .subscribe(onNext: { dto in
        
        // 사용자 이름
        Observable<String>.just(dto.displayName).bind(to: self.nameLabel.rx.text).dispose()
        
        // 추천 메뉴 (이미지)
        Observable.from(dto.yourRecommend.products)
          .enumerated()
          .flatMap { (index, elem) in
            self.useCase.getStoredImage(as: "payImageJSON", index: index)
          }
          .observeOn(MainScheduler.instance)
          .subscribe(onNext: { (info, data, index) in
            
            guard let stackView = self.getIndexedStackView(
              at: index,
              from: self.recommendStackView,
              item: self.recommendItemStackView
            ) else {
              return
            }
            
            if let imageView = stackView.arrangedSubviews.first as? UIImageView, let image = UIImage(data: data) {
              Observable<UIImage>.just(image).bind(to: imageView.rx.image).dispose()
            }
          })
          .disposed(by: self.bag)
        
        // 추천 메뉴 (이름)
        Observable.from(dto.yourRecommend.products)
          .enumerated()
          .flatMap { (index, elem) in
            self.useCase.getInfo(elem, index: index).map({ dto in (index, dto)})
          }
          .observeOn(MainScheduler.instance)
          .subscribe(onNext: { index, dto in
            guard let stackView = self.getIndexedStackView(at: index,
                                                           from: self.recommendStackView,
                                                           item: self.recommendItemStackView
            ) else {
              return
            }
            
            if let label = stackView.arrangedSubviews.last as? UILabel {
              Observable<String>.just(dto.view.product_NM).bind(to: label.rx.text).disposed(by: self.bag)
            }
          })
          .disposed(by: self.bag)
        
        // 이 시간대 인기 메뉴(이미지)
        Observable.from(dto.nowRecommend.products)
          .enumerated()
          .flatMap({ (index, productCd) in
            self.useCase.getStoredImage(as: "payImageJSON", index: index)
          })
          .observeOn(MainScheduler.instance)
          .subscribe(onNext: { (info, data, index) in
            
            guard let stackView = self.getIndexedStackView(
              at: index,
              from: self.thisTimeRecommendStackView,
              item: self.thisTimeRecommendItemStackView
            ) else {
              return
            }
            
            if let imageView = stackView.arrangedSubviews.first as? UIImageView, let image = UIImage(data: data) {
              Observable<UIImage>.just(image).bind(to: imageView.rx.image).dispose()
            }
          })
          .disposed(by: self.bag)
        
        Observable.from(dto.nowRecommend.products)
          .enumerated()
          .flatMap { (index, elem) in
            self.useCase.getInfo(elem, index: index).map({ dto in (index, dto)})
          }
          .observeOn(MainScheduler.instance)
          .subscribe(onNext: { index, dto in
            
            guard
              let stackView = self.getIndexedStackView(
                at: index,
                from: self.thisTimeRecommendStackView,
                item: self.thisTimeRecommendItemStackView),
              stackView.arrangedSubviews.count >= 3
            else {
              return
            }
            
            if let label = stackView.arrangedSubviews[1] as? UILabel {
              Observable<String>.just(dto.view.product_NM).bind(to: label.rx.text).disposed(by: self.bag)
            }
            
            if let label = stackView.arrangedSubviews[2] as? UILabel {
              Observable<String>.just(dto.view.product_NM).bind(to: label.rx.text).disposed(by: self.bag)
            }
          })
          .disposed(by: self.bag)
      })
      .disposed(by: bag)
    
    // 썸네일 메인 이벤트 이미지
    useCase.getThumbDataImage()
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { imageData in
        guard let image = UIImage(data: imageData) else {
          return
        }
        
        self.mainEventImageViewHeightConstraint.constant = image.size.height
        self.mainEventImageView.image = image
      })
      .disposed(by: bag)

    // 진행중 이미지
    useCase.getIngList()
      .enumerated()
      .flatMap({ (index, dto) in
        Observable.from(dto.list.item).map({ dto in (index, dto) })
      })
      .flatMap({ (index, dto) in
        self.useCase.getStoredImage(as: dto.mob_THUM, index: index)
      })
      .subscribe(onNext: { (info, data, index) in
        
        guard let stackView = self.getIndexedStackView(
          at: index,
          from: self.ingListStackView,
          item: self.ingListItemStackView
        ) else {
          return
        }
        
        if let imageView = stackView.arrangedSubviews.first as? UIImageView, let image = UIImage(data: data) {
          Observable<UIImage>.just(image).bind(to: imageView.rx.image).dispose()
        }
      })
      .disposed(by: bag)
    
    useCase.getIngList()
      .enumerated()
      .flatMap({ (index, dto) in
        Observable.from(dto.list.item).map({ dto in (index, dto) })
      })
      .subscribe(onNext: { index, dto in
        guard let stackView = self.getIndexedStackView(at: index,
                                                       from: self.ingListStackView,
                                                       item: self.ingListItemStackView
        ) else {
          return
        }
        
        guard
          let bottomStackView = stackView.arrangedSubviews.last as? UIStackView,
          let numberLabel = bottomStackView.arrangedSubviews.first as? UILabel,
          let titleLabel = bottomStackView.arrangedSubviews.last as? UILabel
        else {
          return
        }
        
        Observable<String>.just("\(index+1)").bind(to: numberLabel.rx.text).disposed(by: self.bag)
        Observable<String>.just(dto.title).bind(to: titleLabel.rx.text).disposed(by: self.bag)
      })
      .disposed(by: self.bag)
  }
  
  func getIndexedStackView(at index: Int, from: UIStackView, item: UIStackView) -> UIStackView? {
    var result: UIStackView
    
    if index != 0 {
      if from.arrangedSubviews.count-1 >= index {
        return from.arrangedSubviews[index] as? UIStackView
      }
      
      guard let view = item.copyView() as? UIStackView else {
        return nil
      }
      
      result = view
      from.insertArrangedSubview(view, at: from.arrangedSubviews.count-1)
    } else {
      result = item
    }
    
    return result
  }
}
extension UIView {
  func copyView<T: UIView>() -> T {
    return NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self)) as! T
  }
}
