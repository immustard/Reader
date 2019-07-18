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
        btn.backgroundColor = kColor999
        btn.frame = CGRect(x: 0, y: 150, width: 100, height: 100)
        btn.mst_centerX = kScreenWidth/2
        btn.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        view.addSubview(btn)
    }

    // MARK: - Actions
    @objc func buttonAction() {
        let vc = BookListVC()
//        let vc = ChapterReadVC()
        navigationController?.pushViewController(vc, animated: true)
    }
}

