//
//  MyBagCollectionViewCell.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/15.
//

import UIKit

class MyBagCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var tableView: UITableView!
    
    var titleCellID: String {
        String(describing: MyBagListTableViewTitleCell.self)
    }
    var itemCellID: String {
        String(describing: MyBagListTableViewItemCell.self)
    }
    var descCellID: String {
        String(describing: MyBagListTableViewDescriptionCell.self)
    }
    
    var entities: [any MyBagData] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func resolveUI(_ entities: [any MyBagData]) {
        self.entities = entities
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
}

extension MyBagCollectionViewCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2 + entities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row != 0 else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: titleCellID,
                                                        for: indexPath) as? MyBagListTableViewTitleCell {
                return cell
            }
            
            return .init()
        }
        
        guard indexPath.row-1 != entities.count else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: descCellID,
                                                        for: indexPath) as? MyBagListTableViewDescriptionCell {
                return cell
            }
            
            return .init()
        }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: itemCellID,
                                                    for: indexPath) as? MyBagListTableViewItemCell {
            return cell
        }
        
        return .init()
    }
}

extension MyBagCollectionViewCell: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.row == 0 {
//            return 120
//        } else if indexPath.row-1 == entities.count {
//            return 220
//        } else {
//            return 150
//        }
//    }
}
