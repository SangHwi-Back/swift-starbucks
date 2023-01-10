//
//  OrderAllMenuCollectionViewCell.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/04.
//

import UIKit
import RxSwift
import RxCocoa

class OrderAllCollectionViewCell: UICollectionViewCell {
    
    struct OrderMenuListEntity {
        let title: String
        let subTitle: String?
        let image: Data?
    }
    
    @IBOutlet weak var headerMenuView: UIView!
    @IBOutlet weak var allMenuListCollectionView: UICollectionView!
    
    deinit {
        URLProtocol.unregisterClass(HTTPRequestMockProtocol.self)
    }
    
    let cellIdentifier = String(describing: OrderMenuListCollectionViewCell.self)
    
    var items = [StarbucksItemDTO]() {
        didSet {
            self.itemBinder.onNext(items)
        }
    }
    lazy var itemBinder = PublishSubject<[StarbucksItemDTO]>()
    
    private var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func initialBind() {
        URLProtocol.registerClass(HTTPRequestMockProtocol.self)
        
        allMenuListCollectionView.register(OrderMenuListCollectionViewCell.self,
                                           forCellWithReuseIdentifier: cellIdentifier)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        layout.minimumLineSpacing = 8
        layout.itemSize = CGSize(width: contentView.frame.size.width-32,
                                          height: 50)
        
        allMenuListCollectionView.collectionViewLayout = layout
        allMenuListCollectionView.dataSource = nil
        
        itemBinder.bind(to: allMenuListCollectionView.rx
            .items(cellIdentifier: cellIdentifier,
                   cellType: OrderMenuListCollectionViewCell.self))
        { [weak disposeBag] (row, element, cell) in
            
            cell.contentView
                .subviews.forEach { $0.removeFromSuperview() }
            
            let imageView = UIImageView()
            let titleLabel = UILabel()
            let stackView = UIStackView()
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            stackView.translatesAutoresizingMaskIntoConstraints = false
            
            stackView.axis = .vertical
            stackView.spacing = 3
            stackView.distribution = .fillProportionally
            stackView.addArrangedSubview(titleLabel)
            
            titleLabel.font = titleLabel.font.withSize(12)
            titleLabel.minimumScaleFactor = 0.2
            titleLabel.numberOfLines = 2
            
            cell.contentView.addSubview(imageView)
            cell.contentView.addSubview(stackView)
            
            if
                let url = Bundle.main.url(forResource: element.name,
                                         withExtension: "jpg"),
                let disposeBag
            {
                URLSession.shared.rx
                    .response(request: URLRequest(url: url))
                    .map({ UIImage(data: $0.data) })
                    .bind(to: imageView.rx.image)
                    .disposed(by: disposeBag)
            }
            
            titleLabel.text = element.title
            
            [
                imageView.leadingAnchor
                    .constraint(equalTo: cell.contentView.leadingAnchor),
                imageView.topAnchor
                    .constraint(equalTo: cell.contentView.topAnchor),
                imageView.bottomAnchor
                    .constraint(equalTo: cell.contentView.bottomAnchor),
                imageView.widthAnchor
                    .constraint(equalToConstant: 50),
                
                stackView.leadingAnchor
                    .constraint(equalTo: imageView.trailingAnchor, constant: 8),
                stackView.trailingAnchor
                    .constraint(equalTo: cell.contentView.trailingAnchor),
                stackView.topAnchor
                    .constraint(equalTo: cell.contentView.topAnchor),
                stackView.bottomAnchor
                    .constraint(equalTo: cell.contentView.bottomAnchor),
            ].forEach {
                $0.isActive = true
            }
            
            cell.menuImageView = imageView
            cell.menuTitleLabel = titleLabel
            cell.menuLabelStackView = stackView
        }
        .disposed(by: disposeBag)
    }
    
    func resolveUI(_ jsonTitle: String) {
        let url = Bundle.main.url(forResource: jsonTitle, withExtension: "json")
        getFoodImageDataTitled(title: jsonTitle, jsonURL: url)
            .subscribe(onNext: { entities in
                self.items.append(contentsOf: entities)
            })
            .disposed(by: disposeBag)
    }
    
    private func getFoodImageDataTitled(title: String, jsonURL: URL?) -> Observable<[StarbucksItemDTO]> {
        guard let jsonURL else {
            return Observable.error(UseCaseError.urlError(jsonURL.getErrorMessage))
        }
        
        return URLSession.shared.rx.response(request: URLRequest(url: jsonURL))
            .map({ result -> [StarbucksItemDTO] in
                if let error = result.response.getRequestError {
                    throw error
                }
                
                guard let result = try? JSONDecoder().decode(StarbucksArray.self, from: result.data) else {
                    throw UseCaseError.decodeFailed(result.response.url.getErrorMessage)
                }
                
                return result.foods
            })
    }
}

class OrderMenuListCollectionViewCell: UICollectionViewCell {
    
    var parent: OrderAllCollectionViewCell?
    var entity: StarbucksItemDTO?
    
    // MARK: - Insert view programmatically. CollectionViewDelegate cannot catch moment IBOutlets initialized.
    var menuImageView: UIImageView?
    var menuTitleLabel: UILabel?
    var menuLabelStackView: UIStackView?
}

private extension HTTPURLResponse {
    var getRequestError: Error? {
        guard self.isSuccess else {
            return UseCaseError.requestError(self.statusCode)
        }
        
        return nil
    }
}

private extension Optional where Wrapped == URL {
    var getErrorMessage: String {
        ("Error occured at " + (self?.absoluteString ?? "unkown URL") + ".")
    }
}
