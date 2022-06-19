//
//  TestViewController.swift
//  BeckBucks
//
//  Created by 백상휘 on 2022/06/17.
//

import UIKit
import SwiftUI
class TestViewController: UIViewController {
    
    private var tableViewData = [
        CommonTableViewData(
            secionHeader: "iPad",
            data: ["iPad Pro, iPad Air, iPad, iPad mini"],
            sectionFooter: "Youtube Player"),
        CommonTableViewData(
            secionHeader: "iPhone",
            data: ["iPhone 13", "iPhone 12", "iPhone 11", "iPhone SE"])
    ]
    
    private var nullViewData: [CommonTableViewData?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CommonTableView {
            CommonTableViewData(
                secionHeader: "MacBook",
                data: ["MacBook Air", "MacBook Pro", "iMac", "Mac mini", "Mac Studio", "Studio Display", "Mac Pro", "Pro Display XDR"])
            for data in tableViewData {
                data
            }
        } _: { tableview in
            self.view.addSubview(tableview)
            
            tableview.translatesAutoresizingMaskIntoConstraints = false
            
            [
                NSLayoutConstraint(item: tableview, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: tableview, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: tableview, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: tableview, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: -150)
            ].forEach {
                $0.isActive = true
            }
        }

    }
}

// MARK: - Custom TableView

class CommonTableView: UITableView {
    var comonDataSource: CommonTableViewDataSource?
}

// MARK: - Custom DataSource

class CommonTableViewDataSource: NSObject, UITableViewDataSource {
    
    var data: [CommonTableViewData] = []
    
    func numberOfSections(in tableView: UITableView) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data[section].data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        let label = UILabel()
        
        label.text = data[indexPath.section].data[indexPath.row]
        label.textAlignment = .center
        
        cell.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        [
            NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: cell, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: cell, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: label, attribute: .trailing, relatedBy: .equal, toItem: cell, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal, toItem: cell, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: label, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .height, multiplier: 1, constant: 30)
        ].forEach {
            $0.isActive = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        data[section].secionHeader
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        data[section].sectionFooter
    }
}

// MARK: - Custom DataSource's Data(Entity)

public struct CommonTableViewData {
    var secionHeader: String?
    let data: [String]
    var sectionFooter: String?
}

// MARK: - ViewBuilder

@resultBuilder
public struct CommonTableViewBuilder {
    public static func buildArray(_ components: [[CommonTableViewData]]) -> [CommonTableViewData] {
        return Array(components.joined())
    }
    
    public static func buildBlock(_ components: [CommonTableViewData]...) -> [CommonTableViewData] {
        return Array(components.joined())
    }
    
    public static func buildExpression(_ expression: CommonTableViewData) -> [CommonTableViewData] {
        return [expression]
    }
}

// MARK: - DSL 형식의 초기화 메소드 선언

extension CommonTableView {
    
    @discardableResult
    convenience init(
        @CommonTableViewBuilder _ content: () -> [CommonTableViewData],
        _ completionHandler: ((CommonTableView)->Void)? = nil
    ) {
        self.init()
        comonDataSource = CommonTableViewDataSource()
        comonDataSource?.data = content()
        dataSource = comonDataSource
        completionHandler?(self)
        reloadData()
    }
}
