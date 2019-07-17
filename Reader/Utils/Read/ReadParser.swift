 //
//  ReadParser.swift
//  Reader
//
//  Created by 张宇豪 on 2019/7/8.
//  Copyright © 2019 张宇豪. All rights reserved.
//

import UIKit

class ReadParser: NSObject {
    // MARK: - Class Methods
    static func parseContent(content: String, bounds: CGRect) -> CTFrame {
        let attrStr = NSMutableAttributedString(string: content)
        let attribute = getAttribute()
        attrStr.setAttributes(attribute, range: NSRange(location: 0, length: content.mst_charLength))
        let setterRef = CTFramesetterCreateWithAttributedString(attrStr)
        let pathRef = CGPath(rect: bounds, transform: nil)
        let framRef = CTFramesetterCreateFrame(setterRef, CFRangeMake(0, 0), pathRef, nil)
        
        return framRef
    }
    
    static func getAttribute() -> Dictionary<NSAttributedString.Key, Any> {
        var dic: Dictionary<NSAttributedString.Key, Any> = [:]
        dic[NSAttributedString.Key.font] = UIFont.systemFont(ofSize: ReadConfig.default.fontSize)
        dic[NSAttributedString.Key.foregroundColor] = ReadConfig.default.fontColor
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = ReadConfig.default.lineSpace
        paragraph.alignment = .justified
        dic[NSAttributedString.Key.paragraphStyle] = paragraph
        
        return dic
    }
}
