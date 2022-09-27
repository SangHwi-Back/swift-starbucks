import Foundation
import UIKit
import RxSwift
import RxCocoa

class ContentsViewController: UIViewController {
  
  @IBOutlet weak var mainScrollView: UIScrollView!
  
  @IBOutlet weak var nameLabel: UILabel!
  
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
  private var disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    recommendView.addSubview(recommendScrollView)
    processingView.addSubview(processingScrollView)
    currentRecommendView.addSubview(currentRecommendScrollView)
    
    useCase.getRecommendationsForUser()
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] item in
        if let titledImageView = self?.recommendScrollView.insertView(ViewImageTitled.self) as? ViewImageTitled {
          titledImageView.setImageAndTitle(imageData: item.1, title: item.0.title)
        }
      })
      .disposed(by: disposeBag)
    
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
      .disposed(by: disposeBag)
    
    useCase.getIngList()
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] data in
        if let titledImageView = self?.processingScrollView.insertView(ViewImageSubTitled.self) as? ViewImageSubTitled {
          titledImageView.imageView?.image = UIImage(data: data)
          titledImageView.setTitles(title: "ING Title(None)", subTitle: "ING SubTitle(None)")
        }
      })
      .disposed(by: disposeBag)
    
    Completable
      .create { event in
        let disposables = Disposables.create()
        event(.completed)
        return disposables
      }
      .delay(RxTimeInterval.seconds(3), scheduler: MainScheduler.instance)
      .subscribe(onCompleted: { [weak self] in
        self?.disposeBag = DisposeBag()
      })
      .disposed(by: disposeBag)
  }
  
  @IBAction func seeAllButtonTouchUpInside(_ sender: UIButton) {
  }
}
