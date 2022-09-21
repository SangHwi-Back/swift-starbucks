import Foundation
import UIKit
import RxSwift
import RxCocoa

class ContentsViewController: UIViewController {
  
  @IBOutlet weak var mainScrollView: UIScrollView!
  
  @IBOutlet weak var nameLabel: UILabel!
  
//  @IBOutlet weak var recommendScrollView: RecommendScrollView!
//  @IBOutlet weak var recommendScrollViewWidthConstraint: NSLayoutConstraint!
//  @IBOutlet weak var recommendFirstView: UIView!
  
  @IBOutlet weak var recommendView: UIView!
  lazy var recommendScrollView = RecommendScrollView(frame: recommendView.bounds)
  
  @IBOutlet weak var mainEventImageView: UIImageView!
  @IBOutlet weak var mainEventImageViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var seeAllButton: UIButton!
  
  @IBOutlet weak var processingView: UIView!
  lazy var processingScrollView = RecommendScrollView(frame: processingView.bounds)
  @IBOutlet weak var currentRecommendView: UIView!
  lazy var currentRecommendScrollView = RecommendScrollView(frame: currentRecommendView.bounds)
  
  let useCase = HomeMainUseCase()
  private var bag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    recommendView.addSubview(recommendScrollView)
    processingView.addSubview(processingScrollView)
    currentRecommendView.addSubview(currentRecommendScrollView)
    
    let mainDTOObservable = useCase.getMainInfo().share()
    mainDTOObservable
      .map({ dto -> String? in dto?.displayName})
      .bind(to: self.nameLabel.rx.text)
      .disposed(by: bag)
    
    let productsObservable = mainDTOObservable.flatMap({ dto in Observable.from(dto?.yourRecommend.products ?? [String]()) })
    
    Observable.zip(
        productsObservable.enumerated()
          .flatMap { (index, _) in self.useCase.getStoredImageData(JSONname: "payImageJSON", index: index) },
        productsObservable.enumerated()
          .flatMap { (index, cd) in self.useCase.getStoredItemInfo(key: cd, index: index) }
      )
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] data, dto in
        guard let self = self else { return }
        
        if let titledImageView = self.recommendScrollView.insertView(ViewImageTitled.self) as? ViewImageTitled {
          titledImageView.imageView?.image = UIImage(data: data)
          titledImageView.titleLabel?.text = dto.view.product_NM
          
          self.recommendScrollView.reloadContentSizeWidth()
        }
        
        if let subTitledImageView = self.currentRecommendScrollView.insertView(ViewImageTitled.self) as? ViewImageTitled {
          subTitledImageView.imageView?.image = UIImage(data: data)
          subTitledImageView.titleLabel?.text = dto.view.product_NM
          
          self.currentRecommendScrollView.reloadContentSizeWidth()
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
    useCase.getIngList()?
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] dto in
        guard let self = self else { return }
        
        for item in dto.list {
          if let titledImageView = self.processingScrollView.insertView(ViewImageSubTitled.self) as? ViewImageSubTitled {
            if let url = URL(string: item.img_UPLOAD_PATH)?.appendingPathComponent(item.mob_THUM) {
              titledImageView.setImage(from: url)
            }
            
            titledImageView.titleLabel?.text = item.title
            titledImageView.subTitleLabel?.text = item.sbtitle_NAME
            
            self.processingScrollView.reloadContentSizeWidth()
          }
        }
      })
      .disposed(by: bag)
  }
  
  @IBAction func seeAllButtonTouchUpInside(_ sender: UIButton) {
  }
}

extension UIView {
  func copyView<T: UIView>() -> T {
    return NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self)) as! T
  }
}
