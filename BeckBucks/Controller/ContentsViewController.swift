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
    
    // 메인 리스트
    useCase.getMainInfo()
      .observeOn(MainScheduler.instance)
      .subscribe { [weak self] event in
        switch event {
        case .success(let data):
          if let titledImageView = self?.recommendScrollView.insertView(ViewImageTitled.self) as? ViewImageTitled {
            titledImageView.setImageAndTitle(imageData: data, title: "Main Usecase Title(None)1")
          }
          if let subTitledImageView = self?.currentRecommendScrollView.insertView(ViewImageTitled.self) as? ViewImageTitled {
            subTitledImageView.setImageAndTitle(imageData: data, title: "Main Usecase Title(None)2")
          }
        case .error(let error):
          print("[Error] \(error)")
        }
      }
      .disposed(by: bag)
    
    // 썸네일 메인 이벤트
    useCase.getThumbDataImage()
      .observeOn(MainScheduler.instance)
      .subscribe { [weak self] event in
        switch event {
        case .success(let data):
          let image = UIImage(data: data)
          self?.mainEventImageView.image = image
          self?.mainEventImageViewHeightConstraint.constant = image?.size.height ?? 300
        case .error(let error):
          print("[Error] \(error)")
        }
      }
      .disposed(by: bag)
    
    // 이 시간대 인기 메뉴
    useCase.getIngList()
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] data in
        if let titledImageView = self?.processingScrollView.insertView(ViewImageSubTitled.self) as? ViewImageSubTitled, let data = data {
          titledImageView.imageView?.image = UIImage(data: data)
          titledImageView.setTitles(title: "ING Title(None)", subTitle: "ING SubTitle(None)")
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
