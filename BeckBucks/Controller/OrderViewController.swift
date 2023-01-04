//
//  OrderViewController.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/03.
//

import UIKit

class OrderViewController: UIViewController {
    
    let useCase = HomeMainUseCase()
    
    @IBOutlet weak var menuListView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = menuListView.frame.size
        
        collectionView.collectionViewLayout = layout
    }
}
