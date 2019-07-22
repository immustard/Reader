//
//  ViewController.swift
//  Reader
//
//  Created by 张宇豪 on 2019/7/16.
//  Copyright © 2019 Mustard. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let btn = UIButton(type: .custom)
        btn.setTitle("txt", for: .normal)
        btn.backgroundColor = kColorRandom
        btn.frame = CGRect(x: 0, y: 150, width: 100, height: 100)
        btn.mst_centerX = kScreenWidth/2
        btn.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        view.addSubview(btn)
        
        let insertBtn = UIButton(type: .custom)
        insertBtn.setTitle("insert", for: .normal)
        insertBtn.backgroundColor = kColorRandom
        insertBtn.addTarget(self, action: #selector(insertAction), for: .touchUpInside)
        view.addSubview(insertBtn)
        
        insertBtn.snp.makeConstraints { (make) in
            make.center.equalTo(self.view)
            make.size.equalTo(CGSize(width: 100, height: 100))
        }
        
        let deleteBtn = UIButton(type: .custom)
        deleteBtn.setTitle("delete", for: .normal)
        deleteBtn.backgroundColor = kColorRandom
        deleteBtn.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
        view.addSubview(deleteBtn)
        
        deleteBtn.snp.makeConstraints { (make) in
            make.centerX.size.equalTo(insertBtn)
            make.top.equalTo(insertBtn.snp_bottomMargin).offset(120)
        }
    }

    // MARK: - Actions
    @objc func buttonAction() {
        let vc = BookListVC()
//        let vc = ChapterReadVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func insertAction() {
        let url = Bundle.main.url(forResource: "mdjyml", withExtension: "txt")

        ReadUtilities.localBookModel(byURL: url!) { (model) in
            
        }
    }
    
    @objc func deleteAction() {
        RealmBookTool.deleteAll()
    }
}

