//
//  MenuDetailViewController.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/23.
//

import UIKit
import RxSwift

class MenuDetailViewController: UIViewController {

    @IBOutlet weak var menuImageView: UIImageView!
    @IBOutlet weak var menuTitleLabel: UILabel!
    @IBOutlet weak var menuEngTitleLabel: UILabel!
    @IBOutlet weak var menuDescriptionLabel: UILabel!
    @IBOutlet weak var menuPriceTagLabel: UILabel!
    @IBOutlet weak var hotIcedOptionStackView: UIStackView!
    @IBOutlet weak var hotButton: UIButton!
    @IBOutlet weak var icedButton: UIButton!
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var nutritionInfoButton: UIButton!
    @IBOutlet weak var alergyInfoButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var orderButton: UIButton!
    
    let layout = UICollectionViewFlowLayout()
    var VM: MenuDetailViewModel?
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        
        layout.itemSize = CGSize(width: (view.frame.width - 32) / 4, height: collectionView.frame.height)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.minimumInteritemSpacing = 8
        layout.scrollDirection = .horizontal
        
        collectionView.collectionViewLayout = layout
        
        hotIcedOptionStackView.setCornerRadius()
        orderButton.setCornerRadius()
        
        if let imageData = VM?.entity.imageData {
            menuImageView.image = UIImage(data: imageData)
        }
        
        menuTitleLabel.text = VM?.entity.title
        menuEngTitleLabel.text = VM?.entity.title
        menuDescriptionLabel.text = Array(repeating: (VM?.entity.title ?? ""), count: 8).joined(separator: " ")
        menuPriceTagLabel.text = VM?.getPrice(from: 90000)
        
        switch VM?.entity.tempOption {
        case .hot:
            icedButton.isHidden = true
        default:
            hotButton.isHidden = true
        }
        
        initialBind()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func initialBind() {
        
        nutritionInfoButton.rx.tap
            .bind(onNext: {
                self.show(UIViewController(), sender: self)
            })
            .disposed(by: disposeBag)
        
        VM?.recommendationsRelay
            .bind(to: collectionView.rx.items(
                cellIdentifier: String(describing: MenuDetailRecommendationCollectionViewCell.self),
                cellType: MenuDetailRecommendationCollectionViewCell.self)
            ) { [weak self] row, element, cell in
                
                if let data = element.imageData {
                    cell.menuImageView.image = UIImage(data: data)
                } else if let useCase = self?.VM, let disposeBag = self?.disposeBag {
                    useCase.getRecommendationImage(at: row)
                        .map({ data -> UIImage? in
                            guard let data = data else { return nil }
                            return UIImage(data: data)
                        })
                        .bind(to: cell.menuImageView.rx.image)
                        .disposed(by: disposeBag)
                }
                
                cell.menuNameLabel.text = element.fileName
            }
            .disposed(by: disposeBag)
        
        VM?.getRecommendations()
    }
}
