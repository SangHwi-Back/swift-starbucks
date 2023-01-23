//
//  SearchViewController.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/22.
//

import UIKit
import RxSwift

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    let selectedQueryPublisher = PublishSubject<String>()
    let useCase = SearchViewUseCase<String>(["모카", "민트", "평촌", "돌체"])
    
    private var selectedItemIndexPath: IndexPath?
    private var cellDisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage(systemName: "magnifyingglass")
        let imageView = UIImageView(image: image?.withTintColor(.black, renderingMode: .alwaysOriginal))
        let viewHeight = searchTextField.frame.height
        let containerView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: viewHeight, height: viewHeight)))
        containerView.addSubview(imageView)
        imageView.frame = CGRect(origin: .zero, size: CGSize(width: viewHeight, height: viewHeight))
        imageView.contentMode = .center
        searchTextField.leftViewMode = .always
        searchTextField.leftView = containerView
        
        initialBind()
    }
    
    private func initialBind() {
        tableView.rx.itemSelected
            .bind(onNext: { [weak self] indexPath in
                self?.selectedItemIndexPath = indexPath
                self?.tableView.deselectRow(at: indexPath, animated: true)
                self?.performSegue(withIdentifier: String(describing: SearchResultViewController.self),
                                   sender: true)
            })
            .disposed(by: useCase.disposeBag)
        
        dismissButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.dismiss(animated: true)
            })
            .disposed(by: useCase.disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if
            let dest = segue.destination as? SearchResultViewController,
            let selectedItemIndexPath {
            
            dest.title = useCase.searchHistory[selectedItemIndexPath.row]
        }
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard useCase.searchHistory.isEmpty == false else { return 0 }
        return useCase.searchHistory.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == useCase.searchHistory.count {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: SearchViewListTableViewFooterCell.self),
                for: indexPath) as? SearchViewListTableViewFooterCell
            else {
                return .init()
            }
            
            cell.removeAllButton.rx.tap
                .bind(onNext: { [weak self] in
                    self?.useCase.removeAllHistories()
                    self?.tableView.reloadData()
                    self?.cellDisposeBag = DisposeBag()
                })
                .disposed(by: cellDisposeBag)
            
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: SearchViewListTableViewCell.self),
            for: indexPath) as? SearchViewListTableViewCell else {
            return .init()
        }
        
        cell.queryLabel.text = useCase.searchHistory[indexPath.row]
        cell.cancelButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.useCase.removeHistory(at: indexPath.row)
                self?.tableView.reloadData()
                self?.cellDisposeBag = DisposeBag()
            })
            .disposed(by: cellDisposeBag)
        
        return cell
    }
}
