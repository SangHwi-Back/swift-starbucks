//
//  NSLayoutAnchor+Extensions.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/17.
//

import UIKit

extension UIView {
    func setTopAnchor(constant: CGFloat) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        return self.topAnchor.constraint(equalTo: self.superview!.topAnchor, constant: constant)
    }
    
    func setLeadingAnchor(constant: CGFloat) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        return self.leadingAnchor.constraint(equalTo: self.superview!.leadingAnchor, constant: constant)
    }
    
    func setTrailingAnchor(constant: CGFloat) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        return self.trailingAnchor.constraint(equalTo: self.superview!.trailingAnchor, constant: constant)
    }
    
    func setBottomAnchor(constant: CGFloat) -> NSLayoutConstraint {
        self.translatesAutoresizingMaskIntoConstraints = false
        return self.bottomAnchor.constraint(equalTo: self.superview!.bottomAnchor, constant: constant)
    }
    
    func setBottomHorizontalAnchor(constant: CGFloat) -> [NSLayoutConstraint] {
        self.translatesAutoresizingMaskIntoConstraints = false
        return [
            self.bottomAnchor.constraint(equalTo: self.superview!.bottomAnchor, constant: constant),
            self.leadingAnchor.constraint(equalTo: self.superview!.leadingAnchor, constant: constant),
            self.trailingAnchor.constraint(equalTo: self.superview!.trailingAnchor, constant: constant),
        ]
    }
    
    func setTopHorizontalAnchor(constant: CGFloat) -> [NSLayoutConstraint] {
        self.translatesAutoresizingMaskIntoConstraints = false
        return [
            self.topAnchor.constraint(equalTo: self.superview!.topAnchor, constant: constant),
            self.leadingAnchor.constraint(equalTo: self.superview!.leadingAnchor, constant: constant),
            self.trailingAnchor.constraint(equalTo: self.superview!.trailingAnchor, constant: constant),
        ]
    }
    
    func setLeadingVerticalAnchor(constant: CGFloat) -> [NSLayoutConstraint] {
        self.translatesAutoresizingMaskIntoConstraints = false
        return [
            self.leadingAnchor.constraint(equalTo: self.superview!.leadingAnchor, constant: constant),
            self.topAnchor.constraint(equalTo: self.superview!.topAnchor, constant: constant),
            self.bottomAnchor.constraint(equalTo: self.superview!.bottomAnchor, constant: constant),
        ]
    }
    
    func setTrailingVerticalAnchor(constant: CGFloat) -> [NSLayoutConstraint] {
        self.translatesAutoresizingMaskIntoConstraints = false
        return [
            self.trailingAnchor.constraint(equalTo: self.superview!.trailingAnchor, constant: constant),
            self.topAnchor.constraint(equalTo: self.superview!.topAnchor, constant: constant),
            self.bottomAnchor.constraint(equalTo: self.superview!.bottomAnchor, constant: constant),
        ]
    }
    
    func setAllSquareAnchor(constant: CGFloat) -> [NSLayoutConstraint] {
        self.translatesAutoresizingMaskIntoConstraints = false
        return [
            self.leadingAnchor.constraint(equalTo: self.superview!.leadingAnchor, constant: constant),
            self.trailingAnchor.constraint(equalTo: self.superview!.trailingAnchor, constant: constant),
            self.topAnchor.constraint(equalTo: self.superview!.topAnchor, constant: constant),
            self.bottomAnchor.constraint(equalTo: self.superview!.bottomAnchor, constant: constant),
        ]
    }
}
