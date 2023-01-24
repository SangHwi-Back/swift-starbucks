//
//  SearchResultTableViewCell.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/23.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {
    
    @IBOutlet weak var resultImageView: UIImageView!
    @IBOutlet weak var resultTitleLabel: LabelWithSFSymbol!
    @IBOutlet weak var resultEngTitleLabel: UILabel!
    @IBOutlet weak var priceTagLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        resultImageView.setCornerRadius()
    }
}
