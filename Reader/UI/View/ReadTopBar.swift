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
    var delegate: ReadTopBarDelegate?
    
    var title: String = "" {
        didSet {
            _titleLabel.text = self.title
        }
    }
    
    // MARK: - Lazy Load
    private var _titleLabel: UILabel!

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
        backBtn.imageEdgeInsets = UIEdgeInsets(top: 9, left: 9, bottom: 9, right: 9)
        addSubview(backBtn)
        
        backBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(self)
            make.leading.equalTo(8)
            make.size.equalTo(CGSize(width: 44, height: 44))
        }
        
        let menuBtn = UIButton(type: .custom)
        menuBtn.setImage(#imageLiteral(resourceName: "catalogue_dark"), for: .normal)
        menuBtn.addTarget(self, action: #selector(p_menuAction), for: .touchUpInside)
        menuBtn.imageEdgeInsets = UIEdgeInsets(top: 12, left: 9, bottom: 12, right: 9)
        addSubview(menuBtn)
        menuBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(backBtn)
            make.trailing.equalTo(-8)
            make.size.equalTo(backBtn)
        }
        
        _titleLabel = UILabel()
        _titleLabel.font = UIFont.systemFont(ofSize: 18)
        _titleLabel.textAlignment = .center
        _titleLabel.textColor = kColor333
        _titleLabel.adjustsFontSizeToFitWidth = true
        addSubview(_titleLabel)
        _titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(backBtn.snp_trailingMargin).offset(8)
            make.centerY.equalTo(backBtn)
            make.trailing.equalTo(menuBtn.snp_leadingMargin).offset(-20)
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
        delegate?.topBackAction()
    }
    
    @objc private func p_menuAction() {
        delegate?.topMenuAction()
    }
}
