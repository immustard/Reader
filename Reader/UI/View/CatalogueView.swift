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

private let HeaderViewHeight: CGFloat = kStatusHeight//+100.0
private let AnimationViewLeading: CGFloat = 100.0
private var CellID = "CatalogueViewCellID"

class CatalogueView: UIView, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {

    // MARK: - Properties
    var model: BookModel!

    var delegate: CatalogueViewDelegate?
    

    private let bgView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: effect)
        view.alpha = 0

        return view
    }()
    
    private let animationView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.tableFooterView = UIView()
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: CellID)

        return tableView
    }()
    
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        return view
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 24)
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    

    
    // MARK: - Initial Methods
    convenience init(model: BookModel) {
        self.init(frame: CGRect.zero)
        
        self.isHidden = true
        self.model = model
        
        addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        addSubview(animationView)
        animationView.snp.makeConstraints { (make) in
            make.leading.equalTo(kScreenWidth)
            make.top.bottom.trailing.equalTo(0)
        }
        
        animationView.addSubview(headerView)
        headerView.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalTo(animationView)
            make.height.equalTo(HeaderViewHeight)
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        animationView.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom)
            make.leading.bottom.trailing.equalTo(animationView)
        }
    
        let tap = mst_addTapGesture(target: self, action: #selector(tapAction(_:)))
        tap.delegate = self
    }

    // MARK: - Instance Methods
    func showAnimation() {
        // 定位tableView位置
        tableView.reloadData()
        tableView.scrollToRow(at: IndexPath(row: model.record.chapter, section: 0), at: .middle, animated: false)

        self.isHidden = false
        UIView.animate(withDuration: kShowAnimationDuration, animations: {
            self.animationView.snp.updateConstraints({ (make) in
                make.leading.equalTo(AnimationViewLeading)
            })
            
            self.bgView.alpha = 0.5
            self.layoutSubviews()
        })
    }
    
    func hideAnimation() {
        UIView.animate(withDuration: kShowAnimationDuration, animations: {
            self.animationView.snp.updateConstraints({ (make) in
                make.leading.equalTo(kScreenWidth)
            })
            
            self.bgView.alpha = 0
            self.layoutSubviews()
        }) { (finished) in
            self.isHidden = true
        }
    }
    
    // MARK: - Actions
    @objc private func tapAction(_ gesture: UITapGestureRecognizer) {
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

        // 判断当前章节
        cell.textLabel?.textColor = (indexPath.row == model.record.chapter) ? kThemeColor : kColor333

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

