//
//  HomeMainDetailViewController.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/27.
//

import UIKit
import RxSwift
import RxCocoa

class HomeMainDetailViewController: UIViewController {
    @IBOutlet weak var titleView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var eventImageView: ResizableImageView!
    
    let imageModel = HomeMainImageFetcher()
    var leftBarButtonItem: UIBarButtonItem?
    var imageFileName: String?
    var titleText: String?
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.tintColor = UIColor.black
        
        self.leftBarButtonItem = navigationItem.leftBarButtonItem
        
        let image = UIImage(systemName: "chevron.backward")
        image?.withTintColor(.darkGray)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image?.withTintColor(.darkGray), style: .plain, target: self, action: #selector(backButtonTouchUpInside(_:)))
        
        titleLabel.text = titleText
        titleView.layer.borderWidth = 1
        titleView.layer.borderColor = UIColor.lightGray.cgColor
        
        if let imageFileName {
            imageModel.getImageFrom(fileName: imageFileName)
                .observeOn(MainScheduler.instance)
                .map({ UIImage(data: $0) })
                .bind(onNext: { [weak eventImageView] image in
                    eventImageView?.contentMode = .scaleToFill
                    eventImageView?.image = image
                    eventImageView?.frame.size.height = eventImageView?.intrinsicContentSize.height ?? 0
                })
                .disposed(by: disposeBag)
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.navigationBar.tintColor = UIColor.tintColor
    }
    
    @objc func backButtonTouchUpInside(_ sender: Any?) {
        navigationController?.popViewController(animated: true)
    }
}
