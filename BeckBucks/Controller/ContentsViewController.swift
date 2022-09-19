import Foundation
import UIKit
import RxSwift
import RxCocoa

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
  private var bag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    var ingListIndex = 0
    var recommendIndex = 0
    var thisTimeRecommendIndex = 0
    
    let mainDTOObservable = useCase.getMainInfo().share()
    mainDTOObservable
      .map({ dto -> String? in dto?.displayName})
      .bind(to: self.nameLabel.rx.text)
      .disposed(by: bag)
    
    let productsObservable = mainDTOObservable.flatMap({ dto in Observable.from(dto?.yourRecommend.products ?? [String]()) })
    Observable
      .zip(
        productsObservable.enumerated()
          .flatMap { (index, _) in self.useCase.getStoredImageData(JSONname: "payImageJSON", index: index) },
        productsObservable.enumerated()
          .flatMap { (index, cd) in self.useCase.getStoredItemInfo(key: cd, index: index) }
      )
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] data, dto in
        guard let self = self else { return }
        
        if let stackView = self.getIndexedStackView(
          at: recommendIndex,
          from: self.recommendStackView,
          item: self.recommendItemStackView
        ) {
          (stackView.arrangedSubviews.first as? UIImageView)?.image = UIImage(data: data)
          (stackView.arrangedSubviews.last as? UILabel)?.text = dto.view.product_NM
          recommendIndex += 1
        }
        
        if
          let stackView = self.getIndexedStackView(
            at: thisTimeRecommendIndex,
            from: self.thisTimeRecommendStackView,
            item: self.thisTimeRecommendItemStackView),
          let bottomStackView = stackView.arrangedSubviews.last as? UIStackView
        {
          (stackView.arrangedSubviews.first as? UIImageView)?.image = UIImage(data: data)
          (bottomStackView.arrangedSubviews.last as? UILabel)?.text = dto.view.product_NM
          (bottomStackView.arrangedSubviews.first as? UILabel)?.text = "\(thisTimeRecommendIndex+1)"
          thisTimeRecommendIndex += 1
        }
      })
      .disposed(by: bag)
    
    // 썸네일 메인 이벤트
    useCase.getThumbDataImage()?
      .observeOn(MainScheduler.instance)
      .compactMap({UIImage(data: $0)})
      .do(onNext: { image in
        self.mainEventImageViewHeightConstraint.constant = image.size.height
      })
      .bind(to: mainEventImageView.rx.image)
      .disposed(by: bag)
    
    // 이 시간대 인기 메뉴
    let ingList = useCase.getIngList()?.share()
    ingList?.observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] dto in
        guard let self = self else { return }
        
        for (index, item) in dto.list.enumerated() {
          guard
            let stackView = self.getIndexedStackView(
              at: index,
              from: self.ingListStackView,
              item: self.ingListItemStackView),
            stackView.arrangedSubviews.count >= 3
          else {
            continue
          }
            
          (stackView.arrangedSubviews[1] as? UILabel)?.text = item.title
          (stackView.arrangedSubviews[2] as? UILabel)?.text = item.sbtitle_NAME
        }
      })
      .disposed(by: bag)
    
    ingList?.observeOn(MainScheduler.instance)
      .flatMap({ dto -> Observable<Data> in
        let itemObservable = Observable<HomeIngItem>.from(dto.list)
        
        return itemObservable
          .compactMap { [weak self] item in
            self?.useCase.getStoredImageData(uploadPath: item.img_UPLOAD_PATH, mobThum: item.mob_THUM)
          }
          .flatMap({ $0 })
      })
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { data in
        guard let stackView = self.getIndexedStackView(at: ingListIndex, from: self.ingListStackView, item: self.ingListItemStackView) else {
          return
        }
        
        (stackView.arrangedSubviews.first as? UIImageView)?.image = UIImage(data: data)
        ingListIndex += 1
      })
      .disposed(by: bag)
  }
  
  func getIndexedStackView(at index: Int, from: UIStackView, item: UIStackView) -> UIStackView? {
    var result: UIStackView
    
    if index != 0 {
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
  
  @IBAction func seeAllButtonTouchUpInside(_ sender: UIButton) {
  }
}

extension UIView {
  func copyView<T: UIView>() -> T {
    return NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self)) as! T
  }
}
