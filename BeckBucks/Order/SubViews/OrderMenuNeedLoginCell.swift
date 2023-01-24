//
//  OrderMenuNeedLoginCell.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/20.
//

import UIKit

class OrderMenuNeedLoginCell: UITableViewCell {
    
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        signInButton.setCornerRadius()
        loginButton.setCornerRadius()
        
        signInButton.layer.borderColor = UIColor.systemGreen.cgColor
        signInButton.layer.borderWidth = 1
    }
}
