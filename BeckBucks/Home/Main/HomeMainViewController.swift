import Foundation
import UIKit
import RxSwift
import RxCocoa

class HomeMainViewController: UIViewController {
  
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
  
  let VM = HomeMainViewModel()
  private var disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    recommendView.addSubview(recommendScrollView)
    processingView.addSubview(processingScrollView)
    currentRecommendView.addSubview(currentRecommendScrollView)
    
    VM.getRecommendationsForUser()
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] titledImageData in
        guard let imageView = self?.recommendScrollView.insertView(ViewImageTitled.self) as? ViewImageTitled else {
          return
        }
        
        imageView.setImageAndTitle(imageData: titledImageData.data, title: titledImageData.title)
      })
      .disposed(by: disposeBag)
    
    VM.getThumbDataImage()
      .observeOn(MainScheduler.instance)
      .subscribe { [weak self] event in
        if case let SingleEvent.success(data) = event, let image = UIImage(data: data) {
          self?.mainEventImageView.image = image
          self?.mainEventImageViewHeightConstraint.constant = image.size.height
        }
      }
      .disposed(by: disposeBag)
    
    VM.getIngList()
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] titledImageData in
        guard let imageView = self?.recommendScrollView.insertView(ViewImageTitled.self) as? ViewImageTitled else {
          return
        }
        
        imageView.setImageAndTitle(imageData: titledImageData.data, title: titledImageData.title)
      })
      .disposed(by: disposeBag)
    
    VM.getThisTimeRecommendList()
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] titledImageData in
        guard let imageView = self?.currentRecommendScrollView.insertView(ViewImageTitled.self) as? ViewImageTitled else {
          return
        }
        
        imageView.setImageAndTitle(imageData: titledImageData.data, title: titledImageData.title)
      })
      .disposed(by: disposeBag)
    
    Completable
      .create { event in
        event(.completed)
        return Disposables.create()
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
