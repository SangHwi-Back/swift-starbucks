//
//  MyBagListTableViewItemCell.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/15.
//

import UIKit

class MyBagListTableViewItemCell: UITableViewCell {
    
    @IBOutlet weak var itemImageView: UIImageView!
    
    func resolveUI() {
        itemImageView.setCornerRadius()
    }
}
