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
    var currentPageThresholdHeight: CGFloat {
        70
    }
}

extension Reactive where Base == UICollectionView {
    /// 위 아래로 70 포인트 이상 스크롤 하였는지 여부를 방출하는 Driver
    ///
    /// 70 포인트 이하의 값을 적용했을 때 가볍게 스크롤을 하면 의도치 않게 다음 페이지로 넘어가게 될 것을 우려하여 70 포인트로 조정하였음.
    var willThroughPageThreshold: Driver<(collectionView: Base, didThrough: Bool)> {
        willBeginDecelerating
            .map({
                guard base.contentOffset.y > 0 else {
                    return (
                        collectionView: base,
                        didThrough: base.contentOffset.y < base.currentPageThresholdHeight
                    )
                }
                
                let maxValue = max(base.contentSize.height, base.contentSize.width)
                let maxValue2 = max(base.frame.width, base.frame.height)
                
                guard maxValue > maxValue2 else {
                    return (
                        collectionView: base,
                        didThrough: false
                    )
                }
                
                let result = base.contentOffset.y + maxValue2 > base.currentPageThresholdHeight + maxValue
                
                return (
                    collectionView: base,
                    didThrough: result
                )
            })
            .throttle(.seconds(6), latest: false, scheduler: MainScheduler.asyncInstance)
            .asDriver(onErrorJustReturn: (
                collectionView: base,
                didThrough: false
            ))
    }
}

extension Reactive where Base == UITableView {
    /// 위 아래로 70 포인트 이상 스크롤 하였는지 여부를 방출하는 Driver
    ///
    /// 70 포인트 이하의 값을 적용했을 때 가볍게 스크롤을 하면 의도치 않게 다음 페이지로 넘어가게 될 것을 우려하여 70 포인트로 조정하였음.
    var willThroughPageThreshold: Driver<(tableView: Base, didThrough: Bool)> {
        willBeginDecelerating
            .map({
                guard base.contentOffset.y > 0 else {
                    return (
                        tableView: base,
                        didThrough: base.contentOffset.y < base.currentPageThresholdHeight
                    )
                }
                
                let maxValue = max(base.contentSize.height, base.contentSize.width)
                let maxValue2 = max(base.frame.width, base.frame.height)
                
                guard maxValue > maxValue2 else {
                    return (
                        tableView: base,
                        didThrough: false
                    )
                }
                
                let result = base.contentOffset.y + maxValue2 > base.currentPageThresholdHeight + maxValue
                
                return (
                    tableView: base,
                    didThrough: result
                )
            })
            .throttle(.seconds(6), latest: false, scheduler: MainScheduler.asyncInstance)
            .asDriver(onErrorJustReturn: (
                tableView: base,
                didThrough: false
            ))
    }
}
