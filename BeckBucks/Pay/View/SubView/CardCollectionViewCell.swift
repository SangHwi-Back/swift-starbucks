//
//  CardCollectionViewCell.swift
//  BeckBucks
//
//  Created by 백상휘 on 2022/10/09.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCellHeightAdjusted {
    
    @IBOutlet weak var cardImageView: UIImageView!
    
    @IBOutlet weak var nameButton: UIButton!
    
    @IBOutlet weak var balanceButton: UIButton!
    
    @IBOutlet weak var barcodeImageView: UIImageView!
    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var descriptionSymbolButton: UIButton!
    
    @IBOutlet weak var autoChargeButton: UIButton!
    @IBOutlet weak var normalChargeButton: UIButton!
    
    private let formatter = NumberFormatter()
    var viewController: UIViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        guard let view = loadViewFromNib() else { return }
        contentView.addSubview(view)
        
        formatter.numberStyle = .decimal
        formatter.currencyDecimalSeparator = " "
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        [
            view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16)
            , view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
            , view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
            , view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ].forEach {
            $0.isActive = true
        }
        
        view.putShadows(offset: CGSize(width: 2, height: 2))
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
    
    func setBalance(_ num: Float, currencyCode: String) {
        let balance = formatter.string(from: NSNumber(value: num)) ?? "0"
        let currencySymbol = Locale(identifier: currencyCode).currencySymbol ?? ""
        balanceButton.setTitle(balance + currencySymbol, for: .normal)
    }
    
    @IBAction func allChargeButtonTouchUpInside(_ sender: UIButton) {
        viewController?.performSegue(withIdentifier: MoneyChargeViewController.storyboardIdentifier,
                                     sender: 1)
    }
    
    @IBAction func normalChargeButtonTouchUpInside(_ sender: UIButton) {
        viewController?.performSegue(withIdentifier: MoneyChargeViewController.storyboardIdentifier,
                                     sender: 0)
    }
}
