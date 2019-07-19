
//
//  ChapterReadVC.swift
//  Reader
//
//  Created by 张宇豪 on 2019/7/7.
//  Copyright © 2019 张宇豪. All rights reserved.
//

import UIKit

class ChapterReadVC: BaseViewController, ReadTopBarDelegate, UIGestureRecognizerDelegate {
    // MARK: - Properties
    private var _readView: ReadView!
    
    private var _topBar: ReadTopBar!
    
    private var _catalogueView: CatalogueView!

    private var _isBarHidden: Bool = true
    
    var model: BookModel!

    // MARK: - Instance Methods
    override var prefersStatusBarHidden: Bool {
        return _isBarHidden
    }
    
    override func initView() {
        super.initView()
        
        navigationController?.setNavigationBarHidden(true, animated: false)

        _readView = ReadView(frame: self.view.frame)
        view.addSubview(_readView)
        
        _topBar = ReadTopBar(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kNavHeight))
        _topBar.mDelegate = self
        view.addSubview(_topBar)
        
        _catalogueView = CatalogueView(model: self.model)
        view.addSubview(_catalogueView)
        
        p_setBarHidden(false)
        
        let tap = view.mst_addTapGesture(target: self, action: #selector(p_tapAction))
        tap.delegate = self

        _readView.frameRef = ReadParser.parseContent(content: model.chapterArray.first?.string(ofPage: 0) ?? "", bounds: ReadConfig.default.displayRect)
    }
    
    // MARK - Private Methods
    private func p_setBarHidden(_ animated: Bool) {
        _topBar.showOrHide(isHidden: _isBarHidden, animated: animated) { 
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    // MARK: - Actions
    override func backAction() {
        
    }

    @objc private func p_menuAction() {
        
    }
    
    @objc private func p_tapAction() {
        _isBarHidden = !_isBarHidden
        p_setBarHidden(true)
    }
}

// MARK: - UIGestureRecognizerDelegate
extension ChapterReadVC {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view!.isDescendant(of: _catalogueView) {
            return false
        } else {
            return true
        }
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

