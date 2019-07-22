//
//  ReadToolBar.swift
//  Reader
//
//  Created by 张宇豪 on 2019/7/22.
//  Copyright © 2019 Mustard. All rights reserved.
//

import UIKit

class ReadToolBar: UIView {
    
    // MARK: - Initial Methods
    init() {
        super.init(frame: CGRect.zero)
        
        backgroundColor = kColorRandom
        
        let line = UIView()
        line.backgroundColor = kColorCCC
        addSubview(line)
        line.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalTo(0)
            make.height.equalTo(1)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    func showOrHide(isHidden: Bool, animated: Bool, completion:(() -> Void)?) {
        let top: CGFloat = isHidden ? kScreenHeight : kScreenHeight-kTabHeight
        
        if animated {
            if isHidden && completion != nil {
                completion!()
            }
            
            UIView.animate(withDuration: kShowAnimationDuration, animations: {
                self.snp.updateConstraints({ (make) in
                    make.top.equalTo(top)
                })
                
                self.superview!.layoutIfNeeded()
            }) { (finished) in
                if !isHidden && completion != nil {
                    completion!()
                }
            }
        } else {
            /// 无动画
            self.snp.updateConstraints { (make) in
                make.top.equalTo(top)
            }

            if completion != nil {
                completion!()
            }
        }
    }
}

