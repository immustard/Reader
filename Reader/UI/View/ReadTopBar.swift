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
}

class ReadTopBar: UIView {
    
    // MARK: - Properties
    var delegate: ReadTopBarDelegate?

    // MARK: - Initial Methods
    override init(frame: CGRect) {
        super.init(frame: frame)

        let backBtn = UIButton(type: .custom)
        backBtn.setImage(#imageLiteral(resourceName: "back_dark"), for: .normal)
        backBtn.frame = CGRect(x: 20, y: mst_bottom-8-40, width: 40, height: 40)
        self.addSubview(backBtn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    @objc private func p_backAction() {
        delegate?.topBackAction()
    }
}
