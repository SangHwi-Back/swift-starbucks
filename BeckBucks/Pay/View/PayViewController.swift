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
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        VM.itemBinder
            .bind(to: cardCollectionView.rx.items(
                cellIdentifier: CardCollectionViewCell.reusableIdentifier,
                cellType: CardCollectionViewCell.self
            )) { [weak self] row, entity, cell in
                
                cell.nameButton.setTitle(entity.name, for: .normal)
                cell.setBalance(entity.balance, currencyCode: entity.currency)
                cell.cardNumberLabel.text = entity.card_number
                cell.barcodeImageView.image = cell.generateBarcode(from: "BeckBucks")
                
                if let vm = self?.VM, let disposeBag = self?.disposeBag {
                    vm.getImage(at: row).toImage()
                        .bind(to: cell.cardImageView.rx.image)
                        .disposed(by: disposeBag)
                }
                
                cell.viewController = self
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
