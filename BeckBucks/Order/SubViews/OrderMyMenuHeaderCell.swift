//
//  OrderMyMenuHeaderCell.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/19.
//

import UIKit

class OrderMyMenuHeaderCell: UITableViewCell {

    @IBOutlet weak var adjustableSwitch: AdjustableSwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setNeedsDisplay()
    }
}
