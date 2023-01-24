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
    
    private let useCase = SearchResultViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar
            .putShadows(offset: CGSize(width: view.frame.width, height: view.frame.height + 3))
        
        useCase.itemsRelay
            .bind(to: tableView.rx.items(cellIdentifier: String(describing: SearchResultTableViewCell.self),
                                         cellType: SearchResultTableViewCell.self)) { [weak self] row, element, cell in
                if let useCase = self?.useCase {
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
                cell.resultEngTitleLabel.text = element.name
                cell.priceTagLabel.text = "9000"
            }
            .disposed(by: useCase.disposeBag)
        
        useCase.getTestData()
    }
}
