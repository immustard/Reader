
//
//  ChapterReadVC.swift
//  Reader
//
//  Created by 张宇豪 on 2019/7/7.
//  Copyright © 2019 张宇豪. All rights reserved.
//

import UIKit

class ChapterReadVC: BaseViewController, ReadTopBarDelegate, CatalogueViewDelegate, UIGestureRecognizerDelegate, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    // MARK: - Properties
    private var _readView: ReadImplVC!
    
    private var _bottomBar: ReadToolBar = ReadToolBar()
    
    private var _catalogueView: CatalogueView!
    
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
    
    // MARK: - Lazy Load
    private lazy var _pageVC: UIPageViewController = {
        let vc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        vc.delegate = self
        vc.dataSource = self
        
        return vc
    }()
    
    private lazy var _statusView: CustomStatusView = {
        let view = CustomStatusView(frame: CGRect(x: 0, y: kScreenHeight-20, width: kScreenWidth, height: 20))
        
        return view
    }()
    
    private lazy var _chapterTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = ReadConfig.default.fontColor
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13)
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()

    private lazy var _topBar: ReadTopBar = {
        let view = ReadTopBar(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kNavHeight))
        view.delegate = self
        
        return view
    }()
    
    // MARK: - Instance Methods
    override var prefersStatusBarHidden: Bool {
        return _isBarHidden
    }
    
    override func initView() {
        super.initView()
        
        view.backgroundColor = UIColor.mst_colorWithHexString("#F0E5C9")
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        addChild(_pageVC)
        view.addSubview(_pageVC.view)
        
        view.addSubview(_statusView)

        _topBar.title = model.title
        view.addSubview(_topBar)
        
        view.addSubview(_bottomBar)
        _bottomBar.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(0)
            make.height.equalTo(kTabHeight)
            make.top.equalTo(kScreenHeight)
        }
        
        view.addSubview(_chapterTitleLabel)
        _chapterTitleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(8)
            make.top.equalTo(kIsPhoneX ? kStatusHeight : 0)
            make.height.equalTo(16)
            make.trailing.equalTo(-8)
        }
        
        _catalogueView = CatalogueView(model: self.model)
        _catalogueView.delegate = self
        view.addSubview(_catalogueView)
        _catalogueView.snp.makeConstraints { (make) in
            make.leading.top.bottom.equalTo(0)
            make.trailing.equalTo(kScreenWidth)     // 目的为了消失动画
        }
        
        view.bringSubviewToFront(_topBar)
        view.bringSubviewToFront(_bottomBar)
        view.bringSubviewToFront(_catalogueView)

        p_setBarHidden(false)
        p_setViewController(chapter: model.record.chapter, page: model.record.page, completion: nil)
        
        p_addGestures()
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
        
        // 设置章节名
        _chapterTitleLabel.text = model.chapterArray[chapter].title
    }
    
    /// 添加手势
    private func p_addGestures() {
        // 点击->菜单
        let tap = view.mst_addTapGesture(target: self, action: #selector(p_tapAction(_:)))
        tap.delegate = self
        
        // TODO: 滑动展示目录
        // 滑动->目录
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(p_swipeAction(_:)))
        swipe.delegate = self
//        view.addGestureRecognizer(swipe)
    }
    
    // MARK: - Actions
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
//                _isTransition = true
                // TODO: 翻页动画的时候, 快速点击有bug
                p_setViewController(chapter: _chapterChange, page: _pageChange) { (finished) in
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
    
    @objc private func p_swipeAction(_ gesture: UISwipeGestureRecognizer) {
        let dir = gesture.direction
        print(dir)
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
    
    private func p_setViewController(chapter: Int, page: Int, completion: ((Bool) -> Void)?) {
        _chapter = chapter
        _page = page
        _pageVC.setViewControllers([p_readView(chapter: chapter, pageCount: page)], direction: .forward, animated: false, completion: completion)
        
        // 记录阅读进度
        p_updateRecord(chapter: chapter, page: page)
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
        if gestureRecognizer is UISwipeGestureRecognizer {
            return false
        }

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

// MARK: - CatalogueViewDelegate
extension ChapterReadVC {
    func catalogueDidSelected(index idx: Int) {
        p_setViewController(chapter: idx, page: 0, completion: nil)
    }
}

