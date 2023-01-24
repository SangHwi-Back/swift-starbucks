//
//  MyBagCollectionViewCell.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/15.
//

import UIKit
import RxSwift
import RxCocoa

class MyBagCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var orderView: UIView!
    
    @IBOutlet weak var countStatusLabel: UILabel!
    @IBOutlet weak var sumPriceLabel: UILabel!
    @IBOutlet weak var orderButton: UIButton!
    
    var navigationController: UINavigationController?
    
    private var titleCellID: String {
        String(describing: MyBagListTableViewTitleCell.self)
    }
    private var itemCellID: String {
        String(describing: MyBagListTableViewItemCell.self)
    }
    private var descCellID: String {
        String(describing: MyBagListTableViewDescriptionCell.self)
    }
    
    private var entities: [any MyBagData] = []
    private var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func resolveUI(_ entities: [any MyBagData]) {
        self.entities = entities
        
        orderView.putShadows()
        tableView.estimatedRowHeight = 100
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rx
            .contentOffset
            .bind(onNext: { offset in
                self.navigationController?
                    .navigationItem.largeTitleDisplayMode = offset.y > 25 ? .automatic : .always
            })
            .disposed(by: disposeBag)
    }
}

extension MyBagCollectionViewCell: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        
        2 + entities.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        guard indexPath.row != 0 else {
            return tableView.dequeueReusableCell(withIdentifier: titleCellID,
                                                 for: indexPath)
        }
        
        guard indexPath.row-1 != entities.count else {
            return tableView.dequeueReusableCell(withIdentifier: descCellID,
                                                 for: indexPath)
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: itemCellID,
                                                       for: indexPath) as? MyBagListTableViewItemCell else {
            return .init()
        }
        
        cell.entity = entities[indexPath.item-1] as? MyBagFoodData
        cell.setUI()
        
        return cell
    }
}

extension MyBagCollectionViewCell: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.cellForRow(at: indexPath)?
            .setSelected(false, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 120
        } else if indexPath.row-1 == entities.count {
            return 150
        } else {
            return UITableView.automaticDimension
        }
    }
}
