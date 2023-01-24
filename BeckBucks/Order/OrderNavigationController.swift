//
//  OrderNavigationController.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/15.
//

import UIKit

class OrderNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UIImage(systemName: "chevron.backward")
        image?.withTintColor(.green)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image?.withTintColor(.green), style: .plain, target: self, action: #selector(backButtonTouchUpInside(_:)))
    }
    
    @objc func backButtonTouchUpInside(_ sender: Any?) {
        navigationController?.popViewController(animated: true)
    }
}
