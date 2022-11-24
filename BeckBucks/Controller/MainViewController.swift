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
    let sharedObservable = useCase.getInitialInfo().share()
    
    sharedObservable.map({$0?.range})
      .bind(to: rangeLabel.rx.text)
      .disposed(by: disposeBag)
    
    sharedObservable.map({$0?.target})
      .bind(to: targetLabel.rx.text)
      .disposed(by: disposeBag)
    
    sharedObservable.map({$0?.description})
      .bind(to: descriptionLabel.rx.text)
      .disposed(by: disposeBag)
    
    sharedObservable.map({$0?.title})
      .bind(to: titleLabel.rx.text)
      .disposed(by: disposeBag)
    
    useCase.getBackgroundImage()
      .map({UIImage.init(data: $0)})
      .bind(to: backgroundImageView.rx.image)
      .disposed(by: disposeBag)
  }
  
  func moveNext() {
    performSegue(withIdentifier: "Contents", sender: self)
  }
}
