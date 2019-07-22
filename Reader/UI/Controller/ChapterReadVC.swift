
//
//  ChapterReadVC.swift
//  Reader
//
//  Created by 张宇豪 on 2019/7/7.
//  Copyright © 2019 张宇豪. All rights reserved.
//

import UIKit

class ChapterReadVC: BaseViewController, ReadTopBarDelegate, UIGestureRecognizerDelegate, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    // MARK: - Properties
    private lazy var _pageVC: UIPageViewController = {
        let vc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        vc.delegate = self
        vc.dataSource = self
        
        return vc
    }()
    
    private var _readView: ReadImplVC!
    
    private var _topBar: ReadTopBar!
    
    private var _bottomBar: ReadToolBar!
    
    private var _catalogueView: CatalogueView!
    
    private var _statusView: CustomStatusView!
    
    private var _isBarHidden: Bool = true
    
    // 当前章节
    private var _chapter: Int = 0
    
    // 当前页数
    private var _page: Int = 0
    
    // 将要展示的章节
    private var _chapterChange: Int = 0
    
    // 将要展示的页数
    private var _pageChange: Int = 0
    
    // 是否正在翻页(点击时启用)
    private var _isTransition: Bool = false
    
    private let _leftRect = CGRect(x: 0, y: 0, width: kScreenWidth/3, height: kScreenHeight)
    private let _rightRect = CGRect(x: kScreenWidth*2/3, y: 0, width: kScreenWidth, height: kScreenHeight)
    
    var model: BookModel!
    
    
    // MARK: - Instance Methods
    override var prefersStatusBarHidden: Bool {
        return _isBarHidden
    }
    
    override func initData() {
        _chapter = model.record.chapter
        _page = model.record.page
    }
    
    override func initView() {
        super.initView()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        addChild(_pageVC)
        _pageVC.setViewControllers([p_readView(chapter: model.record.chapter, pageCount: model.record.page)], direction: .forward, animated: true, completion: nil)
        view.addSubview(_pageVC.view)
        
        _statusView = CustomStatusView(frame: CGRect(x: 0, y: kScreenHeight-20, width: kScreenWidth, height: 20))
        view.addSubview(_statusView)

        _topBar = ReadTopBar(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kNavHeight))
        _topBar.mDelegate = self
        view.addSubview(_topBar)
        
        _bottomBar = ReadToolBar()
        view.addSubview(_bottomBar)
        _bottomBar.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(0)
            make.height.equalTo(kTabHeight)
            make.top.equalTo(kScreenHeight)
        }
        
        _catalogueView = CatalogueView(model: self.model)
        view.addSubview(_catalogueView)
        
        p_setBarHidden(false)
        
        let tap = view.mst_addTapGesture(target: self, action: #selector(p_tapAction(_:)))
        tap.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        _pageVC.view.frame = view.frame
    }
    
    // MARK - Private Methods
    private func p_setBarHidden(_ animated: Bool) {
        _topBar.showOrHide(isHidden: _isBarHidden, animated: animated) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
        
        _bottomBar.showOrHide(isHidden: _isBarHidden, animated: animated, completion: nil)
    }
    
    private func p_updateRecord(chapter: Int, page: Int) {
        _chapter = chapter
        _page = page
        
        let record = model.record
        record.page = page
        record.chapter = chapter
        
        RealmRecordTool.updateRecord(record)
    }
    
    // MARK: - Actions
    override func backAction() {
        
    }
    
    @objc private func p_tapAction(_ gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: view)

        // 点击中间或者工具栏展示时
        if (!_leftRect.contains(point) && !_rightRect.contains(point)) || !_isBarHidden {
            _isBarHidden = !_isBarHidden
            p_setBarHidden(true)
        } else {
            guard !_isTransition else { return }

            let animated = false
            if p_calculatePage(isNext: _rightRect.contains(point)) {
                _chapter = _chapterChange
                _page = _pageChange
//                _isTransition = true
                // TODO: 翻页动画的时候, 快速点击有bug
                _pageVC.setViewControllers([p_readView(chapter: _chapterChange, pageCount: _pageChange)], direction: _rightRect.contains(point) ? .forward : .reverse, animated: animated) { (finished) in
                    if finished {
//                        self._isTransition = false
                    }
                }
            }
            
            if !animated {
                p_updateRecord(chapter: _chapter, page: _page)
            }
        }
    }
    
    private func p_readView(chapter: Int, pageCount: Int) -> ReadImplVC {
        _readView = ReadImplVC()
        _readView.page = pageCount
        _readView.chapter = chapter
        _readView.recordModel = model.record
        _readView.content = model.chapterArray[chapter].string(ofPage: pageCount)
        
        return _readView
    }
    
    private func p_calculatePage(isNext: Bool) -> Bool {
        if isNext {
            _pageChange = _page
            _chapterChange = _chapter
            
            if (_pageChange == model.chapterArray.last!.pageCount-1 && _chapterChange == model.chapterArray.count-1) {
                return false
            }
            
            if (_pageChange == model.chapterArray[_chapterChange].pageCount-1) {
                _chapterChange += 1
                _pageChange = 0
            } else{
                _pageChange += 1
            }
        } else {
            _pageChange = _page
            _chapterChange = _chapter
            
            if _chapterChange == 0 && _pageChange == 0 {
                return false
            }
            
            if _pageChange == 0 {
                _chapterChange -= 1
                _pageChange = model.chapterArray[_chapterChange].pageCount-1
            } else {
                _pageChange -= 1
            }
        }
        
        return true
    }
}

// MARK: - UIPageViewControllerDataSource & Delegate
extension ChapterReadVC {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
//        if _isTransition {
//            return p_readView(chapter: _chapterChange, pageCount: _pageChange)
//        }
        
        if !p_calculatePage(isNext: false) {
            return nil
        } else {
            return p_readView(chapter: _chapterChange, pageCount: _pageChange)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
//        if _isTransition {
//            return p_readView(chapter: _chapterChange, pageCount: _pageChange)
//        }

        if !p_calculatePage(isNext: true) {
            return nil
        } else {
            return p_readView(chapter: _chapterChange, pageCount: _pageChange)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        if let vc = pendingViewControllers.first as? ReadImplVC {
            _chapter = vc.chapter
            _page = vc.page
        } else {
            _chapter = _chapterChange
            _page = _pageChange
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        _statusView.reload()

//        if _isTransition { return }
        
        if !completed {
            let readView = previousViewControllers.first as! ReadImplVC
            _readView = readView
            _page = readView.recordModel!.page
            _chapter = readView.recordModel!.chapter
        } else {
//            _isTransition = false
            p_updateRecord(chapter: _chapter, page: _page)
        }
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

