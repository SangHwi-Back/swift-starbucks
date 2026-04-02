import UIKit
import RxCocoa
import RxSwift

class MainViewController: UIViewController {

  @IBOutlet weak var contentsStackView: UIStackView!
  @IBOutlet weak var backgroundImageView: UIImageView!
  @IBOutlet weak var noLookTodayButton: UIButton!
  @IBOutlet weak var buttonStackView: UIStackView!
  @IBOutlet weak var closeButton: UIButton!
  
  let useCase = InitialEventViewModel()
  let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    CommonUserDefaults
      .getInitialEventDismissDate()
      .subscribe(onSuccess: { [weak self] _ in self?.getInitialEvent() })
      .disposed(by: disposeBag)
    
    noLookTodayButton.rx.tap
      .subscribe({ [weak disposeBag] _ in
        guard let bag = disposeBag else { return }
        
        let currentDateString: (Date) -> String = { date in
          let formatter = DateFormatter()
          formatter.dateFormat = "yyyyMMdd"
          return formatter.string(from: date)
        }
        
        CommonUserDefaults
          .setInitialEventDismissDate(currentDateString(Date()))
          .subscribe({ [weak self] _ in self?.moveNext() })
          .disposed(by: bag)
      })
      .disposed(by: disposeBag)
  
    closeButton.rx.tap
      .subscribe({ [weak self] _ in self?.moveNext() })
      .disposed(by: disposeBag)
  }
  
  func getInitialEvent() {
    useCase.getBackgroundImage()
      .map({UIImage.init(data: $0)})
      .bind(to: backgroundImageView.rx.image)
      .disposed(by: disposeBag)
  }
  
  func moveNext() {
    performSegue(withIdentifier: "Contents", sender: self)
  }
  
  override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
    super.willTransition(to: newCollection, with: coordinator)
    
    if newCollection.verticalSizeClass == .compact {
      backgroundImageView.contentMode = .scaleAspectFit
    } else {
      backgroundImageView.contentMode = .scaleAspectFill
    }
  }
}
