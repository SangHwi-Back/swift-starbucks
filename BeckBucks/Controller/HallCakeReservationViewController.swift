//
//  HallCakeReservationViewController.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/13.
//

import UIKit
import RxSwift
import RxCocoa

class HallCakeReservationViewController: UIViewController {
    
    typealias CELL = HallCakeReservationCollectionViewCell
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var menuSearchButton: UIBarButtonItem!
    
    private let searchVC = UIStoryboard.searchViewController
    let useCase = HallCakeReservationUseCase()
    let formatter = NumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatter.numberStyle = .decimal
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: view.frame.width, height: 80)
        layout.sectionInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        collectionView.collectionViewLayout = layout
        
        useCase.itemsBinder
            .observeOn(MainScheduler.instance)
            .bind(to: collectionView.rx
                .items(cellIdentifier: String(describing: CELL.self),
                       cellType: CELL.self))
        { row, entity, cell in
            
            cell.imageView.image = UIImage(data: entity.imageData)
            cell.titleLabel.text = entity.title
            cell.subTitleLabel.text = entity.engTitle
            cell.priceTagLabel.text = (self.formatter.string(from: NSNumber(value: entity.price)) ?? "") + "원"
            
            cell.setUI()
        }
        .disposed(by: useCase.disposeBag)
        
        searchVC?.selectedQueryPublisher
            .bind(onNext: { [weak self] query in
                self?.present(UIAlertController.commonAlert(query), animated: true)
            })
            .disposed(by: useCase.disposeBag)
        
        menuSearchButton.rx.tap
            .bind(onNext: { [weak self] in
                if let searchVC = self?.searchVC {
                    self?.present(searchVC, animated: true)
                }
            })
            .disposed(by: useCase.disposeBag)
        
        useCase.resolveUI()
    }
    
    @objc func moveBackButtonTouchUpInside(_ sender: Any?) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .automatic
    }
}
