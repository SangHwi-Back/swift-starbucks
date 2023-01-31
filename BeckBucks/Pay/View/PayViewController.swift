//
//  PayViewController.swift
//  BeckBucks
//
//  Created by 백상휘 on 2022/10/09.
//

import UIKit
import RxSwift
import RxCocoa

class PayViewController: UIViewController {
    
    @IBOutlet weak var cardCollectionView: UICollectionView!
    
    @IBOutlet weak var eventImageView: UIImageView!
    
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(cardCollectionView.frame, view.frame)
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(
            width: view.frame.width,
            height: cardCollectionView.frame.height
        )
        
        eventImageView.image = UIImage(named: "pay_event.png")
        
        cardCollectionView.dataSource = self
        cardCollectionView.register(
            UINib(nibName: "CardCollectionViewCell", bundle: Bundle.main),
            forCellWithReuseIdentifier: "CardCollectionViewCell")
        cardCollectionView.collectionViewLayout = layout
        cardCollectionView.reloadData()
    }
}

extension PayViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "CardCollectionViewCell",
            for: indexPath) as? CardCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        
        cell.cardImageView.image = indexPath.getCardImage()
        cell.barcodeImageView.image = cell.generateBarcode(from: "BeckBucks")
        cell.cardBackgroundView.putShadows(offset: CGSize(width: 2, height: 2))
        cell.normalChargeButton.rx.tap
            .bind(onNext: { [weak self] in
                let id = MoneyChargeViewController.storyboardIdentifier
                self?.performSegue(withIdentifier: id, sender: self)
            })
            .disposed(by: disposeBag)
        return cell
    }
}

private extension IndexPath {
    func getCardImage() -> UIImage? {
        switch self.item {
        case 0: return UIImage(named: "card_black.png")
        case 1: return UIImage(named: "card_normal.png")
        case 2: return UIImage(named: "card_black.png")
        default: return nil
        }
    }
}
