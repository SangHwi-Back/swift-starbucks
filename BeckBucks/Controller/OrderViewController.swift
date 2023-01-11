//
//  OrderViewController.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/03.
//

import UIKit
import RxCocoa
import RxSwift

enum OrderCell: Int {
    case allMenu = 0
    case myMenu = 1
    
    func getIndexPath() -> IndexPath {
        IndexPath(item: self.rawValue, section: 0)
    }
}

class OrderViewController: UIViewController {
    
    let useCase = HomeMainUseCase()
    
    private var disposeBag = DisposeBag()
    
    @IBOutlet weak var mainTitleStackView: UIStackView!
    @IBOutlet weak var orderLabel: UILabel!
    
    @IBOutlet weak var allMenuButton: UIButton!
    @IBOutlet weak var myMenuButton: UIButton!
    @IBOutlet weak var cakeReservationButton: UIButton!
    @IBOutlet weak var menuButtonUnderneathView: UIView!
    
    @IBOutlet weak var menuListView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var selectRestaurantView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTitleStackView.putShadows(dx: 4, dy: 4,
                                      offset: CGSize(width: 8, height: 8))
        
        moveUnderneathView(allMenuButton)
        
        collectionView.dataSource = self
        collectionView.reloadData()
        collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] _ in
                self?.performSegue(withIdentifier: "orderViewItemView",
                                   sender: self)
            })
            .disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = collectionView.frame.size
        
        collectionView.collectionViewLayout = layout
        
        allMenuButtonTouchUpInside(allMenuButton)
    }
    
    @IBAction func allMenuButtonTouchUpInside(_ sender: UIButton) {
        
        collectionView.scrollToItem(at: OrderCell.allMenu.getIndexPath(),
                                    at: .left,
                                    animated: true)
        moveUnderneathView(sender)
    }
    
    @IBAction func myMenuButtonTouchUpInside(_ sender: UIButton) {
        
        collectionView.scrollToItem(at: OrderCell.myMenu.getIndexPath(),
                                    at: .right,
                                    animated: true)
        moveUnderneathView(sender)
    }
    
    @IBAction func cakeReservationButtonTouchUpInside(_ sender: UIButton) {
        
        performSegue(withIdentifier: "orderViewCakeView",
                     sender: self)
    }
    
    @IBAction func openRestaurantButtonTouchUpInside(_ sender: UIButton) {
        
        performSegue(withIdentifier: "orderViewReservationView",
                     sender: self)
    }
    
    @IBAction func openMyBagButtonTouchUpInside(_ sender: UIButton) {
        
        performSegue(withIdentifier: "orderMyBagView",
                     sender: self)
    }
    
    private func moveUnderneathView(_ button: UIButton) {
        guard button == allMenuButton || button == myMenuButton else { return }
        
        UIView.animate(withDuration: 0.2) { [weak menuButtonUnderneathView] in
            
            menuButtonUnderneathView?.frame.origin.x = button.frame.origin.x
            menuButtonUnderneathView?.frame.size.width = button.frame.width
        }
    }
}

extension OrderViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cellIdentifier = ""
        if indexPath.item == 0 {
            cellIdentifier = String(describing: OrderAllCollectionViewCell.self)
        } else {
            cellIdentifier = String(describing: OrderMyCollectionViewCell.self)
        }
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: cellIdentifier,
            for: indexPath) as? OrderAllCollectionViewCell
        
        cell?.initialBind()
        cell?.resolveUI("food")
        cell?.resolveUI("drink")
        
        return cell
    }
}
