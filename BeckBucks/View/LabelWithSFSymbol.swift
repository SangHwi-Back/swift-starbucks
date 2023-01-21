//
//  LabelWithSFSymbol.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/21.
//

import UIKit

class LabelWithSFSymbol: UILabel {
    var sfSymbolName: String = "pencil" {
        didSet {
            setTextAttachedSFSymbol()
        }
    }
    
    var indexOfSymbol: Int? {
        didSet {
            setTextAttachedSFSymbol()
        }
    }
    
    override var text: String? {
        didSet{
            setTextAttachedSFSymbol()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setTextAttachedSFSymbol() {
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: sfSymbolName)
        imageAttachment.image = UIImage(systemName: sfSymbolName)?.withTintColor(.systemGray4)
        let imageAsString = NSAttributedString(attachment: imageAttachment)
        
        let fullString = NSMutableAttributedString(string: self.text ?? "")
        
        if let indexOfSymbol {
            fullString.insert(imageAsString, at: indexOfSymbol)
        } else {
            fullString.append(imageAsString)
        }
        
        attributedText = fullString
    }
}
