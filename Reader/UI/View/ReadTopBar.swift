//
//  ReadTopBar.swift
//  Reader
//
//  Created by 张宇豪 on 2019/7/18.
//  Copyright © 2019 Mustard. All rights reserved.
//

import UIKit

protocol ReadTopBarDelegate: NSObjectProtocol {
    func topBackAction()
    func topMenuAction()
}

class ReadTopBar: UIView {
    
    // MARK: - Properties
    var mDelegate: ReadTopBarDelegate?

    // MARK: - Initial Methods
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white
        
        p_setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showOrHide(isHidden: Bool, animated: Bool, completion:(() -> Void)?) {
        var top: CGFloat = 0
        
        if isHidden {
            top = -mst_height
        }
        
        if animated {
            /*
             如果隐藏, 此时回调
             目的是让系统状态栏先消失
             */
            if isHidden && completion != nil {
                completion!()
            }
            
            UIView.animate(withDuration: kShowAnimationDuration, animations: {
                self.mst_top = top
            }) { (finished) in
                if !isHidden && completion != nil {
                    completion!()
                }
            }
        } else {
            /// 无动画
            mst_top = top
            if completion != nil {
                completion!()
            }
        }
    }

    // MARK - Private Methods
    private func p_setupSubviews() {
        let backBtn = UIButton(type: .custom)
        backBtn.setImage(#imageLiteral(resourceName: "back_dark"), for: .normal)
        backBtn.addTarget(self, action: #selector(p_backAction), for: .touchUpInside)
        addSubview(backBtn)
        
        backBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(-12)
            make.leading.equalTo(20)
        }
        
        let menuBtn = UIButton(type: .custom)
        menuBtn.setImage(#imageLiteral(resourceName: "catalogue_dark"), for: .normal)
        menuBtn.addTarget(self, action: #selector(p_menuAction), for: .touchUpInside)
        addSubview(menuBtn)
        menuBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(backBtn)
            make.trailing.equalTo(-20)
        }
        
        let line = UIView()
        line.backgroundColor = kColorCCC
        addSubview(line)
        
        line.snp.makeConstraints { (make) in
            make.leading.bottom.trailing.equalTo(0)
            make.height.equalTo(1)
        }
    }
    
    // MARK: - Actions
    @objc private func p_backAction() {
        mDelegate?.topBackAction()
    }
    
    @objc private func p_menuAction() {
        mDelegate?.topMenuAction()
    }
}
