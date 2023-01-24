//
//  SearchNavigationController.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/23.
//

import UIKit
import RxSwift
import RxCocoa

class SearchNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UIImage(systemName: "chevron.backward")
        image?.withTintColor(.green)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image?.withTintColor(.green), style: .plain, target: self, action: #selector(backButtonTouchUpInside(_:)))
    }
    
    @objc func backButtonTouchUpInside(_ sender: Any?) {
        navigationController?.popViewController(animated: true)
    }
    
    var selectedQueryPublisher: PublishSubject<String>? {
        (self.viewControllers.first as? SearchViewController)?.selectedQueryPublisher
    }
}
