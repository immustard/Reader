//
//  ReadConfig.swift
//  Reader
//
//  Created by 张宇豪 on 2019/7/8.
//  Copyright © 2019 张宇豪. All rights reserved.
//

import UIKit

class ReadConfig: NSObject {
    static let `default` = ReadConfig()
    
    // MARK: - Properties
    var fontSize: CGFloat = 16
    var lineSpace: CGFloat = 8
    var fontColor: UIColor = kColor333

    var topSpacing: CGFloat = 40.0
    var bottomSpacing: CGFloat = 40.0
    var leftSpacing: CGFloat = 20.0
    var rightSpacing: CGFloat = 20.0
    
    /// 获取展示区域
    var displayRect: CGRect {
        let left = ReadConfig.default.leftSpacing
        let top = ReadConfig.default.topSpacing
        let width = kScreenWidth-ReadConfig.default.leftSpacing-ReadConfig.default.rightSpacing
        let height = kScreenHeight-ReadConfig.default.topSpacing-ReadConfig.default.bottomSpacing
        
        return CGRect(x: left, y: top, width: width, height: height)
    }
    
    // MARK: - Initial Methods
    private override init() {
        super.init()
    }
}
