//
//  CardCollectionViewCell.swift
//  BeckBucks
//
//  Created by 백상휘 on 2022/10/09.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cardImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    
    @IBOutlet weak var barcodeImageView: UIImageView!
    @IBOutlet weak var cardNumberLabel: UILabel!
    
    @IBOutlet weak var descriptionSymbolButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var autoChargeButton: UIButton!
    @IBOutlet weak var normalChargeButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /// Copied from (hackingwithswift.com/example-code/media/how-to-create-a-barcode)
    func generateBarcode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }
}
