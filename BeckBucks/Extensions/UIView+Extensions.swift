//
//  UIView+Extensions.swift
//  BeckBucks
//
//  Created by 백상휘 on 2022/09/29.
//

import UIKit
import RxSwift

extension UIView {
    
    /// Default frame is `CGRect(x: 0, y: 0, width: 100, height: 100)`
    static func roundedBorderedBox(_ frame: CGRect? = nil) -> UIView {
        let view = UIView(frame: frame ?? CGRect(x: 0, y: 0, width: 100, height: 100))
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 1.0
        view.setCornerRadius(4)
        return view
    }
    
    func setCornerRadius(_ radius: CGFloat? = nil) {
        self.layer.cornerRadius = radius ?? min(self.frame.height, self.frame.width) / 2
        self.clipsToBounds = true
        self.setNeedsDisplay()
    }
    
    func putShadows(dx: CGFloat? = nil, dy: CGFloat? = nil, offset: CGSize? = nil) {
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 8
        
        if let offset {
            layer.shadowOffset = offset
        }
        
        if let dx, let dy {
            let shadowRect = bounds.offsetBy(dx: dx, dy: dy)
            layer.shadowPath = UIBezierPath(rect: shadowRect).cgPath
        }
    }
    
    func loadNibs() -> [Any] {
        let nib = UINib(nibName: String(describing: Self.self),
                        bundle: Bundle.main)
        let instantiatedNib = nib.instantiate(withOwner: self,
                                              options: nil)
        return instantiatedNib
    }
    
    func loadViewFromNib() -> UIView? {
        return loadNibs().first as? UIView
    }
    
    func loadAllViewFromNib() -> [UIView] {
        return loadNibs().compactMap({ $0 as? UIView })
    }
    func copyView<T: UIView>() -> T? {
        return NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self)) as? T
    }
    
    func makeIndicatorAtCenter() -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView()
        indicator.frame = CGRect(
            x: frame.width / 2 - 10,
            y: frame.height / 2 - 10,
            width: 20,
            height: 20)
        indicator.startAnimating()
        return indicator
    }
    
    func delete(after seconds: Int) -> Disposable {
        BehaviorSubject(value: self)
            .delay(.seconds(seconds), scheduler: MainScheduler.asyncInstance)
            .asDriver(onErrorJustReturn: UIView())
            .drive(onNext: { $0.removeFromSuperview() })
    }
}
