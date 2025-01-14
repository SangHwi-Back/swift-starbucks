//
//  OrderViewController.swift
//  BeckBucks
//
//  Created by 백상휘 on 2023/01/03.
//

import UIKit
import RxCocoa
import RxSwift

enum OrderViewCategory: Int {
    case allMenu = 0
    case myMenu = 1
}

enum AllMenuCategory: Int {
    case drink = 0
    case food = 1
}

class OrderViewController: UIViewController {
    
    @IBOutlet weak var menuSearchButton: UIBarButtonItem!
    
    @IBOutlet weak var menuButtonView: UIView!
    @IBOutlet weak var allMenuHeaderView: UIView!
    
    @IBOutlet weak var allMenuButton: UIButton!
    @IBOutlet weak var myMenuButton: UIButton!
    @IBOutlet weak var cakeReservationButton: UIButton!
    @IBOutlet weak var drinkButton: UIButton!
    @IBOutlet weak var foodButton: UIButton!
    @IBOutlet weak var menuButtonUnderneathView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var selectRestaurantView: UIView!
    @IBOutlet weak var restaurantButton: UIButton!
    @IBOutlet weak var myBagButton: UIButton!
    
    private let searchVC = UIStoryboard.searchViewController
    
    private let orderViewCategoryRelay = BehaviorRelay<OrderViewCategory>(value: .allMenu)
    private let allMenuCategoryRelay = BehaviorRelay<AllMenuCategory>(value: .drink)
    
    private let allFoodMenuVM = OrderMainViewModel(jsonName: "food")
    private let allDrinkmenuVM = OrderMainViewModel(jsonName: "drink")
    private let myMenuVM = OrderMainViewModel(jsonName: "food")
    private var disposeBag = DisposeBag()
    
    var selectedItemIndexPath: IndexPath?
    
    var allList: [StarbucksItemDTO] = []
    var myList: [StarbucksItemDTO] = []
    
    var useCase: OrderMainViewModel {
        guard orderViewCategoryRelay.value != .myMenu else {
            return myMenuVM
        }
        
        switch allMenuCategoryRelay.value {
        case .drink:
            return allDrinkmenuVM
        case .food:
            return allFoodMenuVM
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        
        initialBind()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .automatic
    }
    
    private func initialBind() {
        
        tableView.rx.contentOffset
            .asDriver()
            .drive(onNext: { [weak self] offset in
                self?.navigationItem.largeTitleDisplayMode = offset.y < 25 ? .always : .never
            })
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .bind(onNext: { indexPath in
                self.selectedItemIndexPath = indexPath
                self.tableView.deselectRow(at: indexPath, animated: true)
                self.performSegue(
                    withIdentifier: MenuDetailViewController.storyboardIdentifier,
                    sender: true
                )
            })
            .disposed(by: disposeBag)
        
        orderViewCategoryRelay
            .bind(onNext: { [weak self] category in
                self?.allMenuHeaderView.isHidden = category == .myMenu
                
                if category == .myMenu {
                    self?.myMenuVM.itemBinder
                        .onNext(self?.myMenuVM.items ?? [])
                }
                
                if let relay = self?.allMenuCategoryRelay {
                    relay.accept(relay.value)
                }
            })
            .disposed(by: disposeBag)
        
        allMenuCategoryRelay
            .bind { [weak self] stateOfList in
                guard let useCase = self?.useCase else {
                    return
                }
                
                useCase.itemBinder.onNext(useCase.items)
            }
            .disposed(by: disposeBag)
        
        Observable<[StarbucksItemDTO]>
            .merge([
                allFoodMenuVM.itemBinder.asObservable(),
                allDrinkmenuVM.itemBinder.asObservable(),
                myMenuVM.itemBinder.asObservable(),
            ])
            .asDriver(onErrorJustReturn: [])
            .drive { [weak self] list in
                self?.tableView.reloadData()
                
                // TODO: Add Rows Actions.
            }
            .disposed(by: disposeBag)
        
        Observable<Int>.merge([
            allMenuButton.rx.tap.map({ 0 }),
            myMenuButton.rx.tap.map({ 1 })
        ])
        .bind(onNext: { [weak self] num in
            let stateMutate: OrderViewCategory = num == 0 ? .allMenu : .myMenu
            guard stateMutate != self?.orderViewCategoryRelay.value else { return }
            
            self?.orderViewCategoryRelay.accept(stateMutate)
            
            guard let self else { return }
            
            let originX: CGFloat = (num == 0)
            ? self.allMenuButton.frame.minX
            : self.myMenuButton.frame.minX
            
            UIView.animate(withDuration: 0.2) {
                self.menuButtonUnderneathView.frame.origin.x = originX
            }
        })
        .disposed(by: disposeBag)
        
        Observable<Int>.merge([
            drinkButton.rx.tap.map({ 0 }),
            foodButton.rx.tap.map({ 1 })
        ])
        .bind(onNext: { [weak self] num in
            let stateMutate: AllMenuCategory = num == 0 ? .drink : .food
            guard stateMutate != self?.allMenuCategoryRelay.value else { return }
            
            self?.allMenuCategoryRelay.accept(stateMutate)
            
            switch stateMutate {
            case .drink:
                self?.drinkButton.titleLabel?.font = UIFont.listTitleFont
                self?.foodButton.titleLabel?.font = UIFont.subListTitleFont
            case .food:
                self?.drinkButton.titleLabel?.font = UIFont.subListTitleFont
                self?.foodButton.titleLabel?.font = UIFont.listTitleFont
            }
        })
        .disposed(by: disposeBag)
        
        Observable<Int>.merge([
            myBagButton.rx.tap.map({ 0 }),
            restaurantButton.rx.tap.map({ 1 }),
            cakeReservationButton.rx.tap.map({ 2 }),
        ])
        .bind(onNext: { [weak self] num in
            self?.performSegue(withIdentifier: {
                if num == 0 {
                    return "orderMyBagView"
                } else if num == 1 {
                    return "orderViewReservationView"
                } else {
                    return "orderViewCakeView"
                }
            }(), sender: self)
        })
        .disposed(by: disposeBag)
        
        searchVC?.selectedQueryPublisher?
            .bind(onNext: { [weak self] query in
                self?.present(UIAlertController.commonAlert(query), animated: true)
            })
            .disposed(by: disposeBag)
        
        menuSearchButton.rx.tap
            .bind(onNext: { [weak self] in
                if let searchVC = self?.searchVC {
                    self?.present(searchVC, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        allFoodMenuVM.fetch()
        allDrinkmenuVM.fetch()
        myMenuVM.fetch()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? MenuDetailViewController {
            guard
                let indexPath = selectedItemIndexPath,
                let entity = {
                    if orderViewCategoryRelay.value == .myMenu {
                        return myMenuVM.getItem(at: indexPath.row)
                    }
                    
                    switch allMenuCategoryRelay.value {
                    case .drink:
                        return allDrinkmenuVM.getItem(at: indexPath.row)
                    case .food:
                        return allFoodMenuVM.getItem(at: indexPath.row)
                    }
                }()
            else {
                return
            }
            
            dest.VM = MenuDetailViewModel(entity: entity)
        }
    }
}

extension OrderViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (orderViewCategoryRelay.value == .myMenu ? 1 : 0) + useCase.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch orderViewCategoryRelay.value {
        case .myMenu:
            guard indexPath.row > 0 else {
                let cell = tableView.dequeueReusableCell(withIdentifier: OrderMyMenuHeaderCell.reusableIdentifier,
                                                         for: indexPath) as? OrderMyMenuHeaderCell
                
                cell?.adjustableSwitch?.switchStateRelay
                    .bind(onNext: {
                        UserDefaults.standard
                            .setValue($0 == .on ? true : false, forKey: "OrderAtHome")
                    })
                    .disposed(by: disposeBag)
                
                return cell ?? .init()
            }
            
            let cellIndex = indexPath.row - 1
            
            let entity = useCase.items[cellIndex]
            let cell = tableView.dequeueReusableCell(withIdentifier: OrderMyMenuTableViewCell.reusableIdentifier, for: indexPath) as? OrderMyMenuTableViewCell
            
            cell?.menuTitleLabel.text = entity.title
            cell?.engTitleLabel.text = entity.engTitle
            cell?.setPrice(Int(entity.menuPrice))
            cell?.descriptionLabel.text = entity.menuDescription
            
            if let imageView = cell?.menuImageView {
                useCase.getImage(at: cellIndex).toImage()
                    .bind(to: imageView.rx.image)
                    .disposed(by: disposeBag)
            }
            
            return cell ?? .init()
        case .allMenu:
            let entity = useCase.items[indexPath.row]
            let cell = tableView.dequeueReusableCell(
                withIdentifier: OrderViewListCell.reusableIdentifier,
                for: indexPath) as? OrderViewListCell
            cell?.titleLabel.text = entity.title
            cell?.subTitleLabel.isHidden = true
            
            if let imageView = cell?.menuImageView {
                useCase.getImage(at: indexPath.row).toImage()
                    .bind(to: imageView.rx.image)
                    .disposed(by: disposeBag)
            }
            
            return cell ?? .init()
        }
    }
}
