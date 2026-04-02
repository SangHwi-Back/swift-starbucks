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
    var CELLID: String {
        CELL.reusableIdentifier
    }
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var menuSearchButton: UIBarButtonItem!
    
    private let searchVC = UIStoryboard.searchViewController
    let VM = HallCakeReservationViewModel()
    let formatter = NumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatter.numberStyle = .decimal
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: collectionView.frame.width, height: 80)
        }
        
        VM.itemsBinder
            .bind(to: collectionView.rx.items(cellIdentifier: CELLID,cellType: CELL.self)
            ) { [weak formatter] row, entity, cell in
                
                cell.imageView.image = UIImage(data: entity.imageData)
                cell.titleLabel.text = entity.title
                cell.subTitleLabel.text = entity.engTitle
                cell.priceTagLabel.text = (formatter?.string(from: NSNumber(value: entity.price)) ?? "") + "원"
                
                cell.setUI()
            }
            .disposed(by: VM.disposeBag)
        
        searchVC?.selectedQueryPublisher?
            .bind(onNext: { [weak self] query in
                self?.present(UIAlertController.commonAlert(query), animated: true)
            })
            .disposed(by: VM.disposeBag)
        
        menuSearchButton.rx.tap
            .bind(onNext: { [weak self] in
                if let searchVC = self?.searchVC {
                    self?.present(searchVC, animated: true)
                }
            })
            .disposed(by: VM.disposeBag)
        
        VM.resolveUI()
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
