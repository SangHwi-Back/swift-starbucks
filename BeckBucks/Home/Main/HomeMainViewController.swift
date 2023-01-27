import Foundation
import UIKit
import RxSwift
import RxCocoa

class HomeMainViewController: UIViewController {
    
    @IBOutlet weak var headerScrollView: UIScrollView!
    @IBOutlet weak var headerScrollViewHeight: NSLayoutConstraint!
    @IBOutlet weak var thumbnailView: UIView!
    @IBOutlet weak var rewardView: UIView!
    
    @IBOutlet weak var gaugeView: UIView!
    @IBOutlet weak var rewardTitleLabel: UILabel!
    @IBOutlet weak var rewardStatusLabel: UILabel!
    
    @IBOutlet weak var headerButtonStackView: UIStackView!
    
    @IBOutlet weak var whatsNewButton: UIButton!
    @IBOutlet weak var couponButton: UIButton!
    
    @IBOutlet weak var bellButton: UIButton!
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var mainEventImageView: UIButton!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var recommendationCollectionView: UICollectionView!
    
    @IBOutlet weak var processingEventView: UIView!
    @IBOutlet weak var processingEventViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var seeAllButton: UIButton!
    
    @IBOutlet weak var newInfoCollectionView: UICollectionView!
    
    @IBOutlet weak var currentMenuCollectionView: UICollectionView!
    
    let VM = HomeMainViewModel()
    
    private var originalHeaderHeight: CGFloat = 0
    private var headerHeightExceptButtons: CGFloat {
        originalHeaderHeight
        - headerButtonStackView.frame.height
        - (UIDevice.current.hasNotch ? 32 : 16)
    }
    
    private var disposeBag = DisposeBag()
    
    private let layout = UICollectionViewFlowLayout()
    
    let testSubject = PublishSubject<[Int]>()
    
    typealias CELL = MainMenuItemCollectionViewCell
    private var CellID: String {
        String(describing: MainMenuItemCollectionViewCell.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        originalHeaderHeight = headerScrollView.frame.height
        
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: view.frame.width / 3, height: 140)
        layout.minimumInteritemSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        recommendationCollectionView.collectionViewLayout = layout
        newInfoCollectionView.collectionViewLayout = layout
        currentMenuCollectionView.collectionViewLayout = layout
        
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
        
        testSubject
            .bind(to: recommendationCollectionView.rx.items(cellIdentifier: CellID, cellType: CELL.self)) { row, entity, cell in
                
            }
            .disposed(by: disposeBag)
        
        testSubject
            .bind(to: newInfoCollectionView.rx.items(cellIdentifier: CellID, cellType: CELL.self)) { row, entity, cell in
                
            }
            .disposed(by: disposeBag)
        
        testSubject
            .bind(to: currentMenuCollectionView.rx.items(cellIdentifier: CellID, cellType: CELL.self)) { row, entity, cell in
                
            }
            .disposed(by: disposeBag)
        
        testSubject.onNext([1,2,3,4,5,6,7,8,9,10])
    }
}
