//
//  CatalogueView.swift
//  Reader
//
//  Created by 张宇豪 on 2019/7/18.
//  Copyright © 2019 Mustard. All rights reserved.
//

import UIKit

protocol CatalogueViewDelegate: NSObjectProtocol {
    func catalogueDidSelected(index idx: Int)
}

class CatalogueView: UIView, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {

    // MARK: - Properties
    var model: BookModel!

    var delegate: CatalogueViewDelegate?
    
    private let HeaderViewHeight: CGFloat = 100.0

    private var tableView: UITableView!
    
    private var headerView: UIView!
    
    private var CellID = "CatalogueViewCellID"

    
    // MARK: - Initial Methods
    convenience init(model: BookModel) {
        self.init(frame: CGRect(x: kScreenWidth, y: 0, width: kScreenWidth, height: kScreenHeight))
        
        self.model = model
        
        backgroundColor = kColor333.withAlphaComponent(0.4)
        
        tableView = UITableView(frame: CGRect(x: 100, y: kNavHeight+HeaderViewHeight, width: kScreenWidth-100, height: kScreenHeight-kNavHeight-HeaderViewHeight), style: .plain)
//        tableView.sectionHeaderHeight = 0.1
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: CellID)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        tableView.dataSource = self
        tableView.delegate = self
        addSubview(tableView)
        
        headerView = UIView(frame: CGRect(x: tableView.mst_left, y: 0, width: tableView.mst_width, height: kNavHeight+HeaderViewHeight))
        headerView.backgroundColor = .orange
        addSubview(headerView)
    
        let tap = mst_addTapGesture(target: self, action: #selector(tapAction(_:)))
        tap.delegate = self
    }

    // MARK: - Instance Methods
    // TODO: 完善动画
    func showAnimation() {
        UIView.animate(withDuration: kShowAnimationDuration, animations: {
            self.mst_left = 0
        })
    }
    
    func hideAnimation() {
        UIView.animate(withDuration: kShowAnimationDuration, animations: {
            self.mst_left = kScreenWidth
        })
    }
    
    // MARK: - Actions
    @objc private func tapAction(_ gesture: UITapGestureRecognizer) {
        // FIXME: 解决tap响应问题
        let tableViewPoint = gesture.location(in: tableView)
        let headerViewPoint = gesture.location(in: headerView)
        
        if !tableView.bounds.contains(tableViewPoint) && !headerView.bounds.contains(headerViewPoint) {
            hideAnimation()
        }
    }
}

// MARK: - UITableViewDataSource & Delegate
extension CatalogueView {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.chapterArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellID)!
        cell.textLabel?.text = model.chapterArray[indexPath.row].title
        cell.selectionStyle = .none

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)

        hideAnimation()
        delegate?.catalogueDidSelected(index: indexPath.row)
    }
}

// MARK: - UIGestureRecognizerDelegate
extension CatalogueView {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let point = touch.location(in: tableView)
        if tableView.bounds.contains(point) {
            return false
        }

        return true
    }
}

