
//
//  ChapterReadVC.swift
//  Reader
//
//  Created by 张宇豪 on 2019/7/7.
//  Copyright © 2019 张宇豪. All rights reserved.
//

import UIKit

class ChapterReadVC: BaseViewController, ReadTopBarDelegate {
    // MARK: - Properties
    private var _readView: ReadView!
    
    private var _topBar: ReadTopBar!
    
    var model: BookModel!

    // MARK: - Instance Methods
    override func initView() {
        super.initView()
        
        navigationController?.setNavigationBarHidden(true, animated: false)

        _readView = ReadView(frame: self.view.frame)
        view.addSubview(_readView)
        
        _topBar = ReadTopBar(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kNavHeight))
        _topBar.delegate = self
        view.addSubview(_topBar)
    }
}

// MARK: - Actions
extension ChapterReadVC {
    @objc private func p_backAction() {
        
    }
}

// MARK: - ReadTopBarDelegate
extension ChapterReadVC {
    func topBackAction() {
        navigationController?.popViewController(animated: true)
    }
}
