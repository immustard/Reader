//
//  BaseViewController.swift
//  Reader
//
//  Created by 张宇豪 on 2019/7/4.
//  Copyright © 2019 张宇豪. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        initData()
        initView()
        bindingNotification()
    }

    // MARK: - Instance Methods
    func initData() {
        
    }

    func initView() {
        view.backgroundColor = .white
    }
    
    func bindingNotification() {
        
    }
    
    // MARK: - UITableViewDataSource & Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell(style: .default, reuseIdentifier: "")
    }
    
    // MARK: - Lazy Load
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.backgroundColor = kBgColor
        tableView.tableFooterView = UIView()

        tableView.dataSource = self
        tableView.delegate = self
        
        return tableView
    }()
    
}
