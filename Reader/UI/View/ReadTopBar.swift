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

    // MARK: - Initial Methods
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white
        
        let backBtn = UIButton(type: .custom)
        backBtn.setImage(#imageLiteral(resourceName: "back_dark"), for: .normal)
        backBtn.frame = CGRect(x: 20, y: mst_bottom-12-30, width: 30, height: 30)
        backBtn.addTarget(self, action: #selector(p_backAction), for: .touchUpInside)
        self.addSubview(backBtn)
        
        let menuBtn = UIButton(type: .custom)
        menuBtn.setImage(#imageLiteral(resourceName: "catalogue_dark"), for: .normal)
        menuBtn.frame = CGRect(x: mst_width-20-30, y: mst_bottom-17-20, width: 30, height: 20)
        menuBtn.addTarget(self, action: #selector(p_menuAction), for: .touchUpInside)
        self.addSubview(menuBtn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    @objc private func p_backAction() {
        delegate?.topBackAction()
    }
    
    @objc private func p_menuAction() {
        delegate?.topMenuAction()
    }
}
