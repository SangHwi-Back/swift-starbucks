//
//  UIStoryboard+Extensions.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/22.
//

import UIKit

extension UIStoryboard {
    static var searchViewController: SearchViewController? {
        let storyboard = UIStoryboard(name: "Contents", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: SearchViewController.self))
        vc.modalPresentationStyle = .fullScreen
        return vc as? SearchViewController
    }
}
