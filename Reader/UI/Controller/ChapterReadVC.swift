
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
    
    private var _catalogueView: CatalogueView!
    
    var model: BookModel!

    // MARK: - Instance Methods
    override func initView() {
        super.initView()
        
//        navigationController?.setNavigationBarHidden(true, animated: false)

        _readView = ReadView(frame: self.view.frame)
        view.addSubview(_readView)
        
//        _topBar = ReadTopBar(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kNavHeight))
//        _topBar.mDelegate = self
//        view.addSubview(_topBar)
        
        _catalogueView = CatalogueView(model: self.model)
        view.addSubview(_catalogueView)
        
        p_setupNavigationBar()
        
        _readView.frameRef = ReadParser.parseContent(content: model.chapterArray.first?.string(ofPage: 0) ?? "", bounds: ReadConfig.default.displayRect)
    }
    
    private func p_setupNavigationBar() {
        let backItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back_dark"), style: .plain, target: self, action: #selector(p_backAction))
        navigationController?.navigationItem.leftBarButtonItem = backItem
        
        let menuItem = UIBarButtonItem(image: #imageLiteral(resourceName: "catalogue_dark"), style: .plain, target: self, action: #selector(p_menuAction))
        navigationItem.rightBarButtonItem = menuItem
    }
    
    // MARK: - Actions
    @objc private func p_backAction() {
        
    }
    
    @objc private func p_menuAction() {
        
    }
}

// MARK: - ReadTopBarDelegate
extension ChapterReadVC {
    func topBackAction() {
        navigationController?.popViewController(animated: true)
    }

    func topMenuAction() {
        _catalogueView.showAnimation()
    }
}

