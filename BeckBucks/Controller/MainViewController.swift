import UIKit
import RxCocoa
import RxSwift

class MainViewController: UIViewController {

  @IBOutlet weak var backgroundImageView: UIImageView!
  @IBOutlet weak var rangeLabel: UILabel!
  @IBOutlet weak var targetLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  
  @IBOutlet weak var noLookTodayButton: UIButton!
  @IBOutlet weak var closeButton: UIButton!
  
  let useCase = InitialEventUseCase()
  let bag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyyMMdd"
    
//    CommonUserDefaults
//      .resetInitialEventDismissDate()
//      .disposed(by: bag)
    
    CommonUserDefaults
      .getInitialEventDismissDate()
      .subscribe(onSuccess: { [weak self] dateString in
        if dateString != formatter.string(from: Date()) {
          self?.getInitialEvent()
        } else {
          self?.moveNext()
        }
      })
      .disposed(by: bag)
    
    noLookTodayButton.rx.tap
      .subscribe { [weak self] _ in
        CommonUserDefaults
          .setInitialEventDismissDate(formatter.string(from: Date()))
          .disposed(by: self?.bag ?? DisposeBag())
        self?.moveNext()
      }
      .disposed(by: bag)
    
    closeButton.rx.tap
      .subscribe { [weak self] _ in
        self?.moveNext()
      }
      .disposed(by: bag)
  }
  
  func getInitialEvent() {
    
    useCase.getInitialInfo()
      .observeOn(MainScheduler.instance)
      .bind { [weak self] dto in
        self?.rangeLabel.text = dto.range
        self?.targetLabel.text = dto.target
        self?.descriptionLabel.text = dto.description
        self?.titleLabel.text = dto.title
      }
      .disposed(by: bag)
    
    useCase.getBackgroundImage()
      .compactMap { data in UIImage(data: data) }
      .observeOn(MainScheduler.instance)
      .bind(to: backgroundImageView.rx.image)
      .disposed(by: bag)
  }
  
  func moveNext() {
    self.performSegue(withIdentifier: "Contents", sender: self)
  }
}

