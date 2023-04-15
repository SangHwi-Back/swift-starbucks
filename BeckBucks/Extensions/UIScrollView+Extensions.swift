//
//  UIScrollView+Extensions.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/04/14.
//

import UIKit
import RxCocoa
import RxSwift

extension UIScrollView {
    var nextPageThresholdHeight: CGFloat {
        30
    }
}

#if os(iOS)
extension Reactive where Base == UITableView {
    var willThroughPageThreshold: Driver<Bool> {
        didEndDecelerating
            .map({
                let maxValue = max(base.contentSize.height, base.contentSize.width)
                let maxValue2 = max(base.frame.width, base.frame.height)
                
                guard maxValue > maxValue2 else { return false }
                
                return base.contentOffset.y + maxValue2 > base.nextPageThresholdHeight + maxValue
            })
            .asDriver(onErrorJustReturn: false)
    }
}

extension Reactive where Base == UICollectionView {
    var willThroughPageThreshold: Driver<Bool> {
        willBeginDecelerating
            .map { Void -> Bool in
                let maxValue = max(base.contentSize.height, base.contentSize.width)
                let maxValue2 = max(base.frame.width, base.frame.height)

                guard maxValue > maxValue2 else { return false }
                
                return base.contentOffset.y + maxValue2 > base.nextPageThresholdHeight + maxValue
            }
            .asDriver(onErrorJustReturn: false)
    }
}
#endif
