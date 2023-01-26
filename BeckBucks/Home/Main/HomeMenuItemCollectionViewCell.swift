//
//  HomeMenuItemCollectionViewCell.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/26.
//

import UIKit

class MainMenuItemCollectionViewCell: UICollectionViewCell {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        guard let view = loadViewFromNib() else { return }
        contentView.addSubview(view)
        view.frame = CGRect(origin: .zero, size: contentView.frame.size)
    }
    
    func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: String(describing: Self.self),
                        bundle: Bundle.main)
        let instantiatedNib = nib.instantiate(withOwner: self,
                                              options: nil)
        return instantiatedNib.first as? UIView
    }
}
