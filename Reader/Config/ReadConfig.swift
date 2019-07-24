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
    var fontSize: CGFloat = 20
    var lineSpace: CGFloat = 15
    var fontColor: UIColor = kColor333

    var topSpacing: CGFloat = kIsPhoneX ? kStatusHeight+20 : kStatusHeight
//    var topSpacing: CGFloat = 40.0
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
    
    var contentAttribute: Dictionary<NSAttributedString.Key, Any> {
        var dic: Dictionary<NSAttributedString.Key, Any> = [:]
        dic[NSAttributedString.Key.font] = UIFont.systemFont(ofSize: self.fontSize)
        dic[NSAttributedString.Key.foregroundColor] = self.fontColor
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = self.lineSpace
        paragraph.alignment = .justified
        dic[NSAttributedString.Key.paragraphStyle] = paragraph
        
        return dic
    }
    
    // MARK: - Initial Methods
    private override init() {
        super.init()
    }
}
