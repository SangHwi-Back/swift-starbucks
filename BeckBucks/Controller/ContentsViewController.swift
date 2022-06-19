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
  private var bag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    useCase.getMainInfo()
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { mainDTO in
        
        // 사용자 이름
        self.nameLabel.text = mainDTO.displayName
        
        // 추천 메뉴(이미지 + 이름)
        let recommendImageObservable = Observable.from(mainDTO.yourRecommend.products).enumerated()
          .flatMap { (index, elem) in
            self.useCase.getStoredJSONAndImageData(JSONname: "payImageJSON", index: index)
          }
        
        let recommendNameObservable = Observable.from(mainDTO.yourRecommend.products).enumerated()
          .flatMap { (index, elem) in
            self.useCase.getStoredItemInfo(key: elem, index: index)
          }
        
        Observable.zip(recommendImageObservable, recommendNameObservable).enumerated()
          .observeOn(MainScheduler.instance)
          .subscribe(onNext: { [weak self] index, element in
            guard let self = self else { return }
            guard let stackView = self.getIndexedStackView(at: index, from: self.recommendStackView, item: self.recommendItemStackView) else {
              return
            }
            
            let imageData = element.0.1
            let viewDTO = element.1.view
            
            if let imageView = stackView.arrangedSubviews.first as? UIImageView {
              imageView.image = UIImage(data: imageData)
            }
            
            if let label = stackView.arrangedSubviews.last as? UILabel {
              label.text = viewDTO.product_NM
            }
          })
          .disposed(by: self.bag)
        
        // 이 시간대 인기 메뉴(이미지)
        let nowRecommendInfoObservable = Observable.from(mainDTO.nowRecommend.products).enumerated()
          .flatMap { (index, elem) in
            self.useCase.getStoredJSONAndImageData(JSONname: "payImageJSON", index: index)
          }
        
        let nowRecommendImageObservable = Observable.from(mainDTO.nowRecommend.products).enumerated()
          .flatMap { (index, elem) in
            self.useCase.getStoredItemInfo(key: elem, index: index)
          }
        
        Observable.zip(nowRecommendInfoObservable, nowRecommendImageObservable).enumerated()
          .observeOn(MainScheduler.instance)
          .subscribe(onNext: { [weak self] index, element in
            guard let self = self else { return }
            guard let stackView = self.getIndexedStackView(at: index, from: self.thisTimeRecommendStackView, item: self.thisTimeRecommendItemStackView) else {
              return
            }
            
            guard
              let imageView = stackView.arrangedSubviews.first as? UIImageView,
              let bottomStackView = stackView.arrangedSubviews.last as? UIStackView,
              let numberLabel = bottomStackView.arrangedSubviews.last as? UILabel,
              let titleLabel = bottomStackView.arrangedSubviews.first as? UILabel
            else {
              return
            }
            
            let imageData = element.0.1
            let viewDTO = element.1.view
            
            imageView.image = UIImage(data: imageData)
            numberLabel.text = viewDTO.product_NM
            titleLabel.text = "\(index+1)"
          })
          .disposed(by: self.bag)
      })
      .disposed(by: bag)
    
    // 썸네일 메인 이벤트
    useCase.getThumbDataImage()
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { imageData in
        guard let image = UIImage(data: imageData) else { return }
        
        self.mainEventImageViewHeightConstraint.constant = image.size.height
        self.mainEventImageView.image = image
      })
      .disposed(by: bag)

    // 이 시간대 인기 메뉴
    let ingInfoObservable = useCase.getIngList().enumerated()
      .flatMap({ (index, ingDTO) in
        Observable.from(ingDTO.list).map({ ingDTO in (index, ingDTO) })
      })
    
    let ingImageObservable = ingInfoObservable
      .flatMap({ (index, ingDTO) in
        self.useCase.getStoredImageData(uploadPath: ingDTO.img_UPLOAD_PATH, mobThum: ingDTO.mob_THUM)
      })
    
    Observable.zip(ingInfoObservable, ingImageObservable).enumerated()
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] index, element in
        guard let self = self else { return }
        guard let stackView = self.getIndexedStackView(at: index,from: self.ingListStackView, item: self.ingListItemStackView) else {
          return
        }
        
        guard stackView.arrangedSubviews.count >= 3,
              let imageView = stackView.arrangedSubviews[0] as? UIImageView,
              let titleLabel = stackView.arrangedSubviews[1] as? UILabel,
              let subTitleLabel = stackView.arrangedSubviews[2] as? UILabel
        else {
          return
        }
        
        let imageData = element.1
        let viewDTO = element.0.1
        
        imageView.image = UIImage(data: imageData)
        titleLabel.text = viewDTO.title
        subTitleLabel.text = viewDTO.sbtitle_NAME
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
