import Foundation
import UIKit
import RxSwift
import RxCocoa

class HomeMainViewController: UIViewController {
    
    @IBOutlet weak var headerScrollView: UIScrollView!
    @IBOutlet weak var headerScrollViewHeight: NSLayoutConstraint!
    @IBOutlet weak var thumbnailView: UIView!
    @IBOutlet weak var mainHeaderImageView: UIImageView!
    
    @IBOutlet weak var rewardView: UIView!
    
    @IBOutlet weak var gaugeView: UIView!
    @IBOutlet weak var rewardTitleLabel: UILabel!
    @IBOutlet weak var rewardStatusLabel: UILabel!
    
    @IBOutlet weak var headerButtonStackView: UIStackView!
    
    @IBOutlet weak var whatsNewButton: UIButton!
    @IBOutlet weak var couponButton: UIButton!
    
    @IBOutlet weak var bellButton: UIButton!
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var mainEventButton: UIButton!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var recommendationCollectionView: UICollectionView!
    
    @IBOutlet weak var processingEventView: UIView!
    @IBOutlet weak var processingEventViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var seeAllButton: UIButton!
    
    @IBOutlet weak var newInfoCollectionView: UICollectionView!
    
    @IBOutlet weak var currentMenuCollectionView: UICollectionView!
    
    let mainVM = HomeMainViewModel()
    let menuVM = HomeMainMenuViewModel()
    let imageModel = HomeMainImageFetcher()
    
    private var originalHeaderHeight: CGFloat = 0
    private var headerHeightExceptButtons: CGFloat {
        originalHeaderHeight
        - headerButtonStackView.frame.height
        - (UIDevice.current.hasNotch ? 32 : 16)
    }
    
    private var disposeBag = DisposeBag()
    
    private var layout: UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return layout
    }
    private lazy var itemContentsLayout: UICollectionViewFlowLayout = {
        let layout = self.layout
        layout.itemSize = CGSize(width: view.frame.width / 3,
                                 height: view.frame.width / 3 + 30)
        return layout
    }()
    private lazy var eventContentsLayout: UICollectionViewFlowLayout = {
        let layout = self.layout
        layout.itemSize = CGSize(width: view.frame.width / 2,
                                 height: view.frame.width / 2 - 30)
        return layout
    }()
    
    typealias CELL = MainMenuItemCollectionViewCell
    private var CellID: String {
        String(describing: MainMenuItemCollectionViewCell.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        originalHeaderHeight = headerScrollView.frame.height
        
        recommendationCollectionView.collectionViewLayout = itemContentsLayout
        newInfoCollectionView.collectionViewLayout = eventContentsLayout
        currentMenuCollectionView.collectionViewLayout = itemContentsLayout
        
        let mainScrollViewOffsetObservable = mainScrollView.rx.contentOffset
            .observeOn(MainScheduler.asyncInstance)
            .filter({ $0.y <= self.headerHeightExceptButtons })
        
        mainScrollViewOffsetObservable
            .map({ self.originalHeaderHeight - $0.y})
            .bind(to: headerScrollViewHeight.rx.constant)
            .disposed(by: disposeBag)
        
        mainScrollViewOffsetObservable
            .map({ 1 - ($0.y / self.headerHeightExceptButtons) })
            .bind(to: thumbnailView.rx.alpha, rewardView.rx.alpha)
            .disposed(by: disposeBag)
        
        mainEventButton.rx.tap
            .bind(onNext: { [weak self] in
                // TODO: View Transition
                print(self?.mainVM.mainEntity?.mainEventImageFileName ?? "Unhandled Error")
            })
            .disposed(by: disposeBag)
        
        mainVM.itemBinder
            .subscribe(onNext: { [weak self] mainDTO in
                guard
                    let disposeBag = self?.disposeBag,
                    let imageModel = self?.imageModel
                else {
                    return
                }
                
                let getPublisher: (String) -> Observable<UIImage?>? = { fileName in
                    imageModel
                        .getImageFrom(fileName: fileName)
                        .map({ UIImage(data: $0) })
                }
                
                if let imageView = self?.mainHeaderImageView,
                   let publisher = getPublisher(mainDTO.mainHeaderImageFileName)
                {
                    publisher
                        .bind(to: imageView.rx.image)
                        .disposed(by: disposeBag)
                }
                
                if let button = self?.mainEventButton,
                   let publisher = getPublisher(mainDTO.mainEventImageFileName)
                {
                    publisher
                        .bind(to: button.rx.backgroundImage())
                        .disposed(by: disposeBag)
                }
                
                Observable<UIImage?>
                    .concat(mainDTO.processingEventImageFileNames.map({
                        imageModel
                            .getImageFrom(fileName: $0)
                            .map({UIImage(data: $0)})
                    }))
                    .compactMap({$0})
                    .observeOn(MainScheduler.asyncInstance)
                    .subscribe(onNext: { image in
                        let imageView = ResizableImageView(image: image)
                        imageView.frame.size.width = self?.view.frame.width ?? 300
                        imageView.frame.size = imageView.intrinsicContentSize
                        imageView.setCornerRadius(8)
                        
                        if let lastView = self?.processingEventView.subviews.last {
                            imageView.frame.origin = CGPoint(x: 0,
                                                             y: lastView.frame.maxY + 2)
                            self?.processingEventViewHeight.constant = imageView.frame.maxY
                        }
                        
                        self?.processingEventView.addSubview(imageView)
                    })
                    .disposed(by: disposeBag)
            })
            .disposed(by: disposeBag)
        
        mainVM.itemBinder
            .map({ $0.whatsNewList })
            .bind(to: newInfoCollectionView.rx.items(cellIdentifier: CellID,
                                                            cellType: CELL.self)
            ) { [weak imageModel, weak disposeBag] row, entity, cell in
                
                if let disposeBag = disposeBag {
                    cell.menuImageView.contentMode = .scaleToFill
                    cell.menuImageView.setCornerRadius(8)
                    imageModel?
                        .getImageFrom(fileName: entity.imageFileName)
                        .map({ UIImage(data: $0) })
                        .bind(to: cell.menuImageView.rx.image)
                        .disposed(by: disposeBag)
                }
                
                cell.menuTitleLabel.text = entity.title
            }
            .disposed(by: disposeBag)
        
        menuVM.recommendMenuBinder
            .bind(to: recommendationCollectionView.rx.items(cellIdentifier: CellID,
                                                     cellType: CELL.self)
            ) { [weak imageModel, weak disposeBag] row, entity, cell in
                
                if let disposeBag = disposeBag {
                    cell.menuImageView.setCornerRadius(8)
                    imageModel?
                        .getImageFrom(fileName: entity.fileName)
                        .map({ UIImage(data: $0) })
                        .bind(to: cell.menuImageView.rx.image)
                        .disposed(by: disposeBag)
                }
                
                cell.menuTitleLabel.text = entity.title
            }
            .disposed(by: disposeBag)
        
        menuVM.currentMenuBinder
            .bind(to: currentMenuCollectionView.rx.items(cellIdentifier: CellID,
                                                         cellType: CELL.self)
            ) { [weak imageModel, weak disposeBag] row, entity, cell in
                
                if let disposeBag = disposeBag {
                    cell.menuImageView.setCornerRadius(8)
                    imageModel?
                        .getImageFrom(fileName: entity.fileName)
                        .map({ UIImage(data: $0) })
                        .bind(to: cell.menuImageView.rx.image)
                        .disposed(by: disposeBag)
                }
                
                cell.menuTitleLabel.text = entity.title
            }
            .disposed(by: disposeBag)
        
        mainVM.fetch()
        menuVM.fetch()
    }
}
