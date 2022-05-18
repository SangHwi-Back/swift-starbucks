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
  let bag = DisposeBag()
  
  private var imageSubject: PublishSubject<(String, String, UIImageView)> {
    let subject = PublishSubject<(String, String, UIImageView)>()
    subject.subscribe(onNext: { resourceComp in // Image API 호출해야 함
      self.useCase.getItemImage(resourceComp.0).map { itemImageDTO -> UIImage? in
        if let url = Bundle.main.url(forResource: itemImageDTO.file.first?.file_NAME, withExtension: "jpg"), let data = try? Data(contentsOf: url) {
          return UIImage(data: data)
        }
        
        return nil
      }
      .bind(to: resourceComp.2.rx.image)
      .dispose()
    })
    
    return subject
  }
  
  deinit {
    imageSubject.disposed(by: bag)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    useCase.getMainInfo()
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] dto in
        guard let self = self else { return }
        guard self.recommendStackView.arrangedSubviews.count >= 3 else { return }
        
        Observable<String>.just(dto.displayName).bind(to: self.nameLabel.rx.text).dispose()
        
        for (index, productCd) in dto.yourRecommend.products.enumerated() {
          var stackView: UIStackView
          
          if index != 0 {
            guard let view = self.recommendItemStackView.copyView() as? UIStackView else {
              continue
            }
            
            stackView = view
            self.recommendStackView.insertArrangedSubview(view, at: self.recommendStackView.arrangedSubviews.count-2)
          } else {
            stackView = self.recommendItemStackView
          }
          
          if let imageView = stackView.arrangedSubviews.first as? UIImageView {
            self.imageSubject.onNext((productCd+"\(index)", "jpg", imageView))
          }
        }
        
        for (index, productCd) in dto.nowRecommend.products.enumerated() {
          var stackView: UIStackView
          
          if index != 0 {
            guard let view = self.thisTimeRecommendItemStackView.copyView() as? UIStackView else {
              continue
            }
            
            stackView = view
            self.thisTimeRecommendStackView.insertArrangedSubview(view, at: self.thisTimeRecommendStackView.arrangedSubviews.count-2)
          } else {
            stackView = self.thisTimeRecommendItemStackView
          }
          
          let imageView = stackView.arrangedSubviews.first as? UIImageView
          let labelStackView = stackView.arrangedSubviews.last as? UIStackView
          let label = labelStackView?.arrangedSubviews.last as? UILabel
          
          (labelStackView?.arrangedSubviews.first as? UILabel)?.text = "\(index+1)"
          
          self.useCase
            .getInfo(productCd, index: index)
            .subscribe(onNext: { infoDto in
              
              if let label = label {
                Observable
                  .just(infoDto.view.product_NM)
                  .bind(to: label.rx.text)
                  .disposed(by: self.bag)
              }
              
              if let imageView = imageView {
                self.imageSubject.onNext((productCd+"\(index)", "jpg", imageView))
              }
            })
            .disposed(by: self.bag)
        }
      })
      .disposed(by: bag)
    
    useCase.getThumbDataImage()
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] imageData in
        guard let self = self, let image = UIImage(data: imageData) else {
          return
        }
        
        self.mainEventImageViewHeightConstraint.constant = image.size.height
        self.mainEventImageView.image = image
      })
      .disposed(by: bag)
    
    useCase.getIngList()
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] dto in
        guard let self = self else { return }
        guard self.recommendItemStackView.arrangedSubviews.count >= 3 else { return }
                
        for (index, item) in dto.list.item.enumerated() {
          
          var stackView: UIStackView
          
          if index != 0 {
            guard let view = self.ingListItemStackView.copyView() as? UIStackView else {
              continue
            }
            
            stackView = view
            self.ingListStackView.insertArrangedSubview(view, at: self.ingListStackView.arrangedSubviews.count-1)
          } else {
            stackView = self.ingListItemStackView
          }
          
          let imageView = stackView.arrangedSubviews[0] as? UIImageView
          let titleLabel = stackView.arrangedSubviews[1] as? UILabel
          let descriptionLabel = stackView.arrangedSubviews[2] as? UILabel
          
          DispatchQueue.main.async {
            titleLabel?.text = item.title
            descriptionLabel?.text = "[설명란] "+item.title
          }
          
          if let imageView = imageView {
            self.imageSubject.onNext((item.mob_THUM, "jpg", imageView))
          }
        }
      })
      .disposed(by: bag)
  }
}
extension UIView {
  func copyView<T: UIView>() -> T {
    return NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self)) as! T
  }
}
