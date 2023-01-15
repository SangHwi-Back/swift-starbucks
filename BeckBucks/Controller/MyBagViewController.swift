//
//  MyBagViewController.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/15.
//

import UIKit
import RxSwift
import RxCocoa

class MyBagViewController: UIViewController {

    @IBOutlet weak var coveringNavigationBackgroundView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var showFoodButton: UIButton!
    @IBOutlet weak var showMerchandiseButton: UIButton!
    @IBOutlet weak var categoryUnderneathView: UIView!
    
    var cellID: String {
        String(describing: MyBagCollectionViewCell.self)
    }
    var emptyCellID: String {
        String(describing: MyBagCollectionViewEmptyCell.self)
    }
    
    let useCase = MyBagUseCase(true)
    
    override func loadView() {
        super.loadView()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        navigationController?.navigationItem.largeTitleDisplayMode = .always
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryUnderneathView.frame
            .origin.x = showFoodButton.frame.minX
        categoryUnderneathView.frame
            .size.width = showFoodButton.frame.width
        showFoodButton.rx.tap
            .bind {
                self.collectionView.scrollToItem(at: .init(item: 0, section: 0),
                                                 at: .left,
                                                 animated: true)
                UIView.animate(withDuration: 0.2) {
                    self.categoryUnderneathView.frame
                        .origin.x = self.showFoodButton.frame.minX
                    self.categoryUnderneathView.frame
                        .size.width = self.showFoodButton.frame.width
                }
            }
            .disposed(by: useCase.disposeBag)
        
        showMerchandiseButton.rx.tap
            .bind {
                self.collectionView.scrollToItem(at: .init(item: 1, section: 0),
                                                 at: .left,
                                                 animated: true)
                UIView.animate(withDuration: 0.2) {
                    self.categoryUnderneathView.frame
                        .origin.x = self.showMerchandiseButton.frame.minX
                    self.categoryUnderneathView.frame
                        .size.width = self.showMerchandiseButton.frame.width
                }
            }
            .disposed(by: useCase.disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = collectionView.frame.size
        
        collectionView.collectionViewLayout = layout
        collectionView.dataSource = self
        collectionView.reloadData()
        
        showFoodButton.sendActions(for: .touchUpInside)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationItem.largeTitleDisplayMode = .automatic
    }
}

extension MyBagViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard indexPath.item != 0 else {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: emptyCellID, for: indexPath) as? MyBagCollectionViewEmptyCell {
                return cell
            }
            
            return .init()
        }
        
        let entity: [any MyBagData] = indexPath.item == 0 ? useCase.foodItems : useCase.merchItems
        
        guard entity.isEmpty == false else {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: emptyCellID, for: indexPath) as? MyBagCollectionViewEmptyCell {
                return cell
            }
            
            return .init()
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? MyBagCollectionViewCell else {
            return .init()
        }
        
        cell.resolveUI(entity)
        cell.tableView.rx
            .contentOffset
            .observeOn(MainScheduler.instance)
            .bind(onNext: { offset in
                self.navigationController?
                    .navigationItem.largeTitleDisplayMode = offset.y > 25 ? .automatic : .always
            })
            .disposed(by: useCase.disposeBag)
        
        return cell
    }
}
