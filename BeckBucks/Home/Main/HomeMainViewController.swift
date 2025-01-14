import Foundation
import UIKit
import RxSwift
import RxCocoa

class HomeMainViewController: UIViewController {
    
    @IBOutlet weak var topLeadingStackView: UIStackView!
    
    @IBOutlet weak var thumbnailView: UIView!
    @IBOutlet weak var thumbnailViewHeight: NSLayoutConstraint!
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
    
    @IBOutlet weak var topRightPrevButton: UIButton!
    @IBOutlet weak var topRightNextButton: UIButton!
    @IBOutlet weak var topRightView: UIView!
    @IBOutlet weak var topRightContentsCollectionView: UICollectionView!
    @IBOutlet weak var topConstraintAtTopRightCollectionView: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraintAtTopRightCollectionView: NSLayoutConstraint!
    
    // MARK: - ViewModels
    let mainVM = HomeMainViewModel()
    let menuVM = HomeMainMenuViewModel()
    let imageModel = HomeMainImageFetcher()
    
    // MARK: - Properties of header
    private var originalHeaderHeight: CGFloat = 0
    private var topPadding: CGFloat {
        UIDevice.current.hasNotch ? 32 : 16
    }
    private var headerHeightExceptButtons: CGFloat {
        originalHeaderHeight + rewardView.frame.height - topPadding
    }
    
    private var topRightBinderIndex = 0
    
    // MARK: - DisposeBag
    private var transitionBag = DisposeBag()
    private var disposeBag = DisposeBag()
    
    // MARK: - CollectionLayout
    private let itemWidth: CGFloat = 120
    private var layout: UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return layout
    }
    
    private lazy var itemContentsLayout: () -> UICollectionViewFlowLayout = {
        let layout = self.layout
        layout.itemSize = CGSize(width: self.itemWidth, height: self.itemWidth + 30)
        return layout
    }
    private lazy var eventContentsLayout: () -> UICollectionViewFlowLayout = {
        let layout = self.layout
        layout.itemSize = CGSize(width: self.itemWidth * 1.5, height: self.itemWidth * 1.5 - 30)
        return layout
    }
    
    // MARK: - Type of Cell
    typealias CELL = MainMenuItemCollectionViewCell
    private var CellID: String {
        MainMenuItemCollectionViewCell.reusableIdentifier
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        originalHeaderHeight = thumbnailViewHeight.constant
        
        recommendationCollectionView.collectionViewLayout = itemContentsLayout()
        newInfoCollectionView.collectionViewLayout = eventContentsLayout()
        currentMenuCollectionView.collectionViewLayout = itemContentsLayout()
        let verticalLayout = itemContentsLayout()
        verticalLayout.scrollDirection = .vertical
        topRightContentsCollectionView.collectionViewLayout = verticalLayout
        
        enablePrevNextButtonAtTopRightView()
        
        let mainScrollViewOffsetObservable = mainScrollView.rx.contentOffset
            .observeOn(MainScheduler.asyncInstance)
            .filter({ $0.y <= self.headerHeightExceptButtons })
        
        mainScrollViewOffsetObservable
            .map({
                let result = self.originalHeaderHeight - $0.y
                return result < 0 ? 0 : result
            })
            .bind(to: thumbnailViewHeight.rx.constant)
            .disposed(by: disposeBag)
        
        mainScrollViewOffsetObservable
            .map({ 1 - ($0.y / self.thumbnailViewHeight.constant) })
            .bind(to: thumbnailView.rx.alpha, rewardView.rx.alpha)
            .disposed(by: disposeBag)
        
        mainEventButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.performSegue(withIdentifier: "HomeMainDetailViewController",
                                   sender: self?.mainVM.mainEntity)
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
        
        mainVM.itemBinder
            .subscribe(onNext: { [weak self] mainDTO in
                guard
                    let disposeBag = self?.disposeBag,
                    let imageModel = self?.imageModel
                else {
                    return
                }
                
                let imageObservable: (String) -> Observable<UIImage?> = { fileName in
                    imageModel
                        .getImageFrom(fileName: fileName)
                        .map({ UIImage(data: $0) })
                        .observeOn(MainScheduler.asyncInstance)
                }
                
                imageObservable(mainDTO.mainHeaderImageFileName)
                    .bind(onNext: { self?.mainHeaderImageView.image = $0 })
                    .disposed(by: disposeBag)
                
                imageObservable(mainDTO.mainEventImageFileName)
                    .bind(onNext: { self?.mainEventButton.setBackgroundImage($0, for: .normal) })
                    .disposed(by: disposeBag)
                
                Observable<UIImage?>
                    .concat(
                        mainDTO.processingEventImageFileNames
                            .map {
                                imageModel
                                    .getImageFrom(fileName: $0)
                                    .map({UIImage(data: $0)})
                            }
                    )
                    .compactMap({$0})
                    .observeOn(MainScheduler.asyncInstance)
                    .subscribe(onNext: { image in
                        let imageView = ResizableImageView(image: image)
                        imageView.resize(pinWidth: (self?.view.frame.width ?? 300) - 32)
                        imageView.setCornerRadius(8)
                        imageView.frame.origin.x = 16
                        
                        if let lastView = self?.processingEventView.subviews.last {
                            imageView.frame.origin.y = lastView.frame.maxY + 8
                            self?.processingEventViewHeight.constant = imageView.frame.maxY
                        }
                        
                        self?.processingEventView.addSubview(imageView)
                    })
                    .disposed(by: disposeBag)
            })
            .disposed(by: disposeBag)
        
        newInfoCollectionView.rx.itemSelected
            .bind(onNext: { [weak self] indexPath in
                guard
                    let entities = self?.mainVM.mainEntity?.whatsNewList,
                    indexPath.item < entities.count
                else {
                    return
                }
                
                self?.performSegue(
                    withIdentifier: HomeMainDetailViewController.storyboardIdentifier,
                    sender: entities[indexPath.item]
                )
            })
            .disposed(by: disposeBag)
        
        recommendationCollectionView.rx.itemSelected
            .bind(onNext: { [weak self] indexPath in
                guard let entity = self?.menuVM.recommendMenus[indexPath.row] else { return }
                self?.itemSelectForNavigation(entity: entity)
            })
            .disposed(by: disposeBag)
        
        currentMenuCollectionView.rx.itemSelected
            .bind(onNext: { [weak self] indexPath in
                guard let entity = self?.menuVM.currentMenus[indexPath.row] else { return }
                self?.itemSelectForNavigation(entity: entity)
            })
            .disposed(by: disposeBag)
        
        topRightContentsCollectionView.rx.willThroughPageThreshold
            .drive(onNext: { [weak self] result in
                guard result.didThrough else { return }
                
                let isUpward = (result.collectionView.contentOffset.y < 0)
                
                self?.topConstraintAtTopRightCollectionView.constant = (isUpward ? 100 : -100)
                self?.bottomConstraintAtTopRightCollectionView.constant = (isUpward ? -100 : 100)
                
                UIView.animate(withDuration: 0.5) {
                    
                    self?.topRightView.layoutIfNeeded()
                } completion: { _ in
                    
                    let containerYPosition = (isUpward ? 0 : result.collectionView.frame.height - 100) + 10
                    let containerWidth = (self?.topRightView.frame.width ?? 200) - 32
                    let containerRect = CGRect(x: 16, y: containerYPosition, width: containerWidth, height: 80)
                    
                    let containerView = UIView.roundedBorderedBox(containerRect)
                    
                    self?.topRightView.addSubview(containerView)
                    let indicator = containerView.makeIndicatorAtCenter()
                    
                    containerView.addSubview(indicator)
                    
                    self?.removeViewAsDimmedInTopRightView(view: containerView)
                }
            })
            .disposed(by: disposeBag)
        
        topRightPrevButton.rx.tap
            .asDriver(onErrorJustReturn: Void())
            .drive(onNext: {
                self.topRightBinderIndex -= 1
                self.enablePrevNextButtonAtTopRightView()
                self.viewLocalBind(isPortrait: false)
            })
            .disposed(by: disposeBag)
        
        topRightNextButton.rx.tap
            .asDriver(onErrorJustReturn: Void())
            .drive(onNext: {
                self.topRightBinderIndex += 1
                self.enablePrevNextButtonAtTopRightView()
                self.viewLocalBind(isPortrait: false)
            })
            .disposed(by: disposeBag)
        
        mainVM.fetch()
        menuVM.fetch()
    }
    
    private func removeViewAsDimmedInTopRightView(view: UIView) {
        BehaviorSubject<(view: UIView, isPrev: Bool)>(value: (view: view, isPrev: view.frame.origin.y == 10))
            .asDriver(onErrorJustReturn: (view: UIView(), isPrev: false))
            .delay(.milliseconds(1200))
            .drive(onNext: { [weak self] viewInfo in
                
                self?.topConstraintAtTopRightCollectionView.constant = 0
                self?.bottomConstraintAtTopRightCollectionView.constant = 0
                
                UIView.animate(withDuration: 0.5) {
                    viewInfo.view.layer.opacity = 0
                    self?.topRightView.layoutIfNeeded()
                } completion: { _ in
                    
                    viewInfo.view.removeFromSuperview()
                    
                    if viewInfo.isPrev {
                        guard let index = self?.topRightBinderIndex, index > 0 else {
                            return
                        }
                        self?.topRightBinderIndex -= 1
                        self?.enablePrevNextButtonAtTopRightView()
                        self?.viewLocalBind(isPortrait: false)
                    }
                    else {
                        // TODO: index 최대값을 비롯한 뷰 상태값을 관리하는 모델이 필요함.
                        guard let index = self?.topRightBinderIndex, index < 1 else {
                            return
                        }
                        self?.topRightBinderIndex += 1
                        self?.enablePrevNextButtonAtTopRightView()
                        self?.viewLocalBind(isPortrait: false)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func enablePrevNextButtonAtTopRightView() {
        
        topRightPrevButton.isEnabled = true
        topRightNextButton.isEnabled = true
        
        if topRightBinderIndex == 0 {
            topRightPrevButton.isEnabled = false
        }
        else if topRightBinderIndex == 1 {
            topRightNextButton.isEnabled = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewLocalBind(isPortrait: view.frame.width < view.frame.height)
    }
    
    override func viewWillTransition(
        to size: CGSize,
        with coordinator: UIViewControllerTransitionCoordinator) {
            super.viewWillTransition(to: size, with: coordinator)
            
            if size.width > size.height { // LandScape
                mainScrollView.contentOffset.y = 0
            }
        }
    
    private func viewLocalBind(isPortrait: Bool) {
        transitionBag = DisposeBag()
        
        localBind(to: recommendationCollectionView,
                  publisher: menuVM.recommendMenuBinder)
        localBind(to: currentMenuCollectionView,
                  publisher: menuVM.currentMenuBinder)
        localBind(to: topRightContentsCollectionView,
                  publisher: topRightBinderIndex == 0 ? menuVM.recommendMenuBinder : menuVM.currentMenuBinder)
    }
    
    func localBind(to view: UICollectionView, publisher: BehaviorRelay<[some StarbucksEntity]>) {
        publisher
            .bind(to: view.rx.items(
                cellIdentifier: CellID,
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
            .disposed(by: transitionBag)
    }
    
    func itemSelectForNavigation(entity: StarbucksItemDTO) {
        let storyboard = UIStoryboard(name: "Contents", bundle: Bundle.main)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: MenuDetailViewController.storyboardIdentifier) as? MenuDetailViewController else {
            return
        }
        
        viewController.VM = MenuDetailViewModel(entity: entity)
        navigationController?.pushViewController(viewController, animated: true)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if
            let dest = segue.destination as? HomeMainDetailViewController,
            let entity = sender as? HomeMainDTO
        {
            dest.title = "이벤트 & 뉴스"
            dest.imageFileName = entity.mainEventImageFileName
            dest.titleText = "Main Event Title Text"
        }
        
        if
            let dest = segue.destination as? HomeMainDetailViewController,
            let entity = sender as? WhatsNewDTO
        {
            dest.title = entity.title
            dest.imageFileName = entity.detailImageFileName
            dest.titleText = entity.subTitle
        }
    }
}
