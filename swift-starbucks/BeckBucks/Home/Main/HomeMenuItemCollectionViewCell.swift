//
//  HomeMenuItemCollectionViewCell.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/26.
//

import UIKit

class MainMenuItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var menuImageView: UIImageView!
    
    @IBOutlet weak var menuTitleLabel: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        guard let view = loadViewFromNib() else { return }
        contentView.addSubview(view)
        view.frame = CGRect(origin: .zero, size: contentView.frame.size)
    }
}
