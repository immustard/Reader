//
//  BookListVC.swift
//  Reader
//
//  Created by 张宇豪 on 2019/7/18.
//  Copyright © 2019 Mustard. All rights reserved.
//

import UIKit

class BookListVC: BaseViewController {

    // MARK: - Properties
    private let CellID = "BookListVCCellID"
    
    private var books: Array<BookModel> = []

    // MARK: - Instance Methods
    override func initData() {
        books = RealmBookTool.queryAll()
    }
    
    override func initView() {
        super.initView()
        
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: CellID)
        view.addSubview(tableView)
    }
    
    // MARK: - UITableViewDataSource & Delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellID)!

        let model = books[indexPath.row]
        cell.textLabel?.text = model.title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = ChapterReadVC()
        vc.model = books[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}
