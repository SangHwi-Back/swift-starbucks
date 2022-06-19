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
    
    CommonUserDefaults
      .getInitialEventDismissDate()
      .subscribe(onSuccess: { [weak self] dateString in
        guard dateString == formatter.string(from: Date()) else {
          self?.getInitialEvent()
          return
        }
        
        self?.moveNext()
      })
      .disposed(by: bag)
  
    noLookTodayButton.rx.tap
      .subscribe({ [weak self] _ in
        guard let self = self else { return }
        CommonUserDefaults
          .setInitialEventDismissDate(formatter.string(from: Date()))
          .subscribe({ _ in
            self.moveNext()
          })
          .disposed(by: self.bag)
      })
      .disposed(by: bag)
  
    closeButton.rx.tap
      .subscribe({ [weak self] _ in
        self?.moveNext()
      })
      .disposed(by: bag)
  }
  
  func getInitialEvent() {
    useCase
      .getInitialInfo()
      .drive(onNext: { [weak self] dto in
        guard let self = self, let dto = dto else { return }
        self.rangeLabel.text = dto.range
        self.targetLabel.text = dto.target
        self.descriptionLabel.text = dto.description
        self.titleLabel.text = dto.title
      })
      .disposed(by: bag)
    
    useCase
      .getBackgroundImage()
      .drive(onNext: { [weak self] data in
        self?.backgroundImageView.image = UIImage(data: data)
      })
      .disposed(by: bag)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    backgroundImageView.image = nil
  }
  
  func moveNext() {
    performSegue(withIdentifier: "Contents", sender: self)
  }
}
