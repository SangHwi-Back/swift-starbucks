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
    
    private let VM = PayViewModel()
    private var cellDisposeBag = DisposeBag()
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(
            width: view.frame.width,
            height: cardCollectionView.frame.height
        )
        
        eventImageView.image = UIImage(named: "pay_event.png")
        
        cardCollectionView.rx.willDisplayCell
            .bind(onNext: { [weak self] event in
                guard let self = self, let cell = event.cell as? CardCollectionViewCell else { return }
                
                self.cellDisposeBag = DisposeBag()
                
                Observable<Int>
                    .merge([
                        cell.normalChargeButton.rx.tap.map({0}),
                        cell.autoChargeButton.rx.tap.map({1})
                    ])
                    .bind(onNext: { [weak self] num in
                        self?.performSegue(
                            withIdentifier: MoneyChargeViewController.storyboardIdentifier,
                            sender: num
                        )
                    })
                    .disposed(by: self.cellDisposeBag)
            })
            .disposed(by: disposeBag)
        
        cardCollectionView.dataSource = self
        cardCollectionView.register(
            UINib(nibName: "CardCollectionViewCell",
                  bundle: Bundle.main),
            forCellWithReuseIdentifier: "CardCollectionViewCell")
        cardCollectionView.collectionViewLayout = layout
        cardCollectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? MoneyChargeViewController {
            let isAuto = (sender as? Int) == 1
            
            dest.isAuto = isAuto
            dest.title = isAuto ? "자동 충전" : "일반 충전"
        }
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
