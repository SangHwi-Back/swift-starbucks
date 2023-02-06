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
    
    @IBOutlet weak var buttonContainer: UIView!
    
    private let VM = PayViewModel(jsonName: "cards")
    private var cellDisposeBag = DisposeBag()
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layoutIfNeeded()
        
        cardCollectionView.rx.willDisplayCell
            .bind(onNext: { [weak self] event in
                guard let cell = event.cell as? CardCollectionViewCell else {
                    return
                }
                
                self?.cellBind(cell, at: event.at)
            })
            .disposed(by: disposeBag)
        
        VM.itemBinder
            .bind(to: cardCollectionView.rx.items(
                cellIdentifier: CardCollectionViewCell.reusableIdentifier,
                cellType: CardCollectionViewCell.self
            )) { row, entity, cell in
                
                cell.nameButton.setTitle(entity.name, for: .normal)
                cell.setBalance(entity.balance, currencyCode: entity.currency)
                cell.cardNumberLabel.text = entity.card_number
                cell.barcodeImageView.image = cell.generateBarcode(from: "BeckBucks")
            }
            .disposed(by: disposeBag)
        
        VM.getImageFrom(fileName: "pay_event").toImage()
            .bind(to: eventImageView.rx.image)
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        view.layoutIfNeeded()
        
        if let layout = cardCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = cardCollectionView.frame.size
        }
        
        VM.fetch()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? MoneyChargeViewController {
            let isAuto = (sender as? Int) == 1
            
            dest.isAuto = isAuto
            dest.title = isAuto ? "자동 충전" : "일반 충전"
        }
    }
    
    func cellBind(_ cell: CardCollectionViewCell, at indexPath: IndexPath) {
        cellDisposeBag = DisposeBag()
        
        Observable<Int>.merge([
            cell.normalChargeButton.rx.tap.map({0}),
            cell.autoChargeButton.rx.tap.map({1})
        ])
        .bind(onNext: { [weak self] num in
            self?.performSegue(
                withIdentifier: MoneyChargeViewController.storyboardIdentifier,
                sender: num
            )
        })
        .disposed(by: cellDisposeBag)
        
        VM.getImage(at: indexPath.item).toImage()
            .bind(to: cell.cardImageView.rx.image)
            .disposed(by: cellDisposeBag)
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

private extension Int {
    func getCardImage() -> UIImage? {
        IndexPath(item: self, section: 0).getCardImage()
    }
}

extension Observable where Element == Data {
    func toImage() -> Observable<UIImage?> {
        self.map({UIImage(data: $0)})
    }
}
