//
//  SearchResultViewController.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/23.
//

import UIKit
import RxSwift
import RxCocoa

class SearchResultViewController: UIViewController {
    
    @IBOutlet weak var showAllButton: UIButton!
    @IBOutlet weak var showBeverageButton: UIButton!
    @IBOutlet weak var showFoodButton: UIButton!
    @IBOutlet weak var showMerchandiseButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    private let VM = SearchResultViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar
            .putShadows(offset: CGSize(width: view.frame.width, height: view.frame.height + 3))
        
        VM.itemsRelay
            .bind(to: tableView.rx.items(cellIdentifier: SearchResultTableViewCell.reusableIdentifier,
                                         cellType: SearchResultTableViewCell.self)
            ) { [weak self] row, element, cell in
                if let useCase = self?.VM {
                    useCase.requestImage(at: row)
                        .map({ data -> UIImage? in
                            guard let data else {
                                return nil
                            }
                            
                            return UIImage(data: data)
                        })
                        .bind(to: cell.resultImageView.rx.image)
                        .disposed(by: useCase.disposeBag)
                }
                
                cell.resultTitleLabel.text = element.title
                cell.resultEngTitleLabel.text = element.fileName
                cell.priceTagLabel.text = "9000"
            }
            .disposed(by: VM.disposeBag)
        
        VM.getTestData()
    }
}
