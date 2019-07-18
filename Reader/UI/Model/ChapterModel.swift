//
//  ChapterModel.swift
//  Reader
//
//  Created by 张宇豪 on 2019/7/16.
//  Copyright © 2019 Mustard. All rights reserved.
//

import UIKit
import RealmSwift

class ChapterModel: Object, NSCopying {

    // MARK: - Properties
    /// 所属书目ID
    @objc dynamic var bookID: Int = 0
    
    /// 章节序列号
    @objc dynamic var idx: Int = 0
    
    /// 章节名
    @objc dynamic var title: String = ""
    
    /// 内容
    @objc dynamic var content: String = "" {
        didSet {
            if pageArrayString.mst_charLength == 0 {
                p_paginate(ReadConfig.default.displayRect)
            }
        }
    }
    
    /// 分页数据
    @objc dynamic private var pageArrayString: String = ""
    
    /// 缓存地址
    @objc dynamic var cachePath: String = ""
    
    /// 章节页数
    @objc dynamic var pageCount: Int = 0

    private var _pageArray: Array<Int> {
        get {
            return p_stringToArray(pageArrayString)
        }
        set {
            pageArrayString = p_arrayToString(newValue)
        }
    }
    
    override var description: String {
        return "chapter idx: \(idx)" + ", bookID: \(bookID)" + ", contentLength: \(content.mst_charLength)" + ", pageArrayCount: \(_pageArray.count)" + ", pageCount: \(pageCount)"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["content"]
    }
}

extension ChapterModel {
    // MARK: - Initial Methods
    func copy(with zone: NSZone? = nil) -> Any {
        let obj = type(of: self).init()
        obj.bookID = bookID
        obj.idx = idx
        obj.title = title
        obj.content = content
        obj.pageCount = pageCount
        obj._pageArray = _pageArray
        
        return obj
    }
}

extension ChapterModel {
    // MARK: - Instance Methods
    func string(ofPage page: Int) -> String {
        if pageArrayString.mst_charLength != 0 && _pageArray.count == 0 {
            let tArr = p_stringToArray(pageArrayString)
            _pageArray = tArr
        }
        
        guard _pageArray.count > page else { return "" }
        
        let local = _pageArray[page]
        var length = 0
        if page < pageCount-1 {
            length = _pageArray[page+1] - _pageArray[page]
        } else {
            length = content.mst_charLength - _pageArray[page]
        }
        
        return content.mst_substring(range: NSRange(location: local, length: length)) ?? ""
    }

    func updateFont() {
        p_paginate(ReadConfig.default.displayRect)
    }
}

extension ChapterModel {
    // MARK - Private Methods
    func p_paginate(_ bounds: CGRect) {
        _pageArray.removeAll()
        
        let mAttrString = NSMutableAttributedString(string: self.content)
        
        let attribute = ReadParser.getAttribute()
        mAttrString.setAttributes(attribute, range: NSRange(location: 0, length: mAttrString.length))
        
        let frameSetter = CTFramesetterCreateWithAttributedString(mAttrString)
        
        let path = CGPath(rect: bounds, transform: nil)
        
        var currentOffset = 0
        var currentInnerOffset = 0
        var hasMorePages = true
        
        // 防止死循环，如果在同一个位置获取CTFrame超过2次，则跳出循环
        let preventDeadLoopSign = currentOffset
        var samePlaceRepeatCount = 0
        
        while hasMorePages {
            if preventDeadLoopSign == currentOffset {
                samePlaceRepeatCount += 1
            } else {
                samePlaceRepeatCount = 0
            }
            
            if samePlaceRepeatCount > 1 {
                // 退出循环前检查一下最后一页是否已经加上
                if _pageArray.count == 0 {
                    _pageArray.append(currentOffset)
                } else {
                    let lastOffset = _pageArray.last!
                    if lastOffset != currentOffset {
                        _pageArray.append(currentOffset)
                    }
                }
                break
            }
            
            _pageArray.append(currentOffset)
            
            let frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(currentOffset, 0), path, nil)
            let range = CTFrameGetVisibleStringRange(frame)
            
            if (range.location + range.length) != mAttrString.length {
                currentOffset += range.length
                currentInnerOffset += range.length
            } else {
                // 已经分完，提示跳出循环
                hasMorePages = false
            }
        }
        
        pageCount = _pageArray.count
        
        pageArrayString = p_arrayToString(_pageArray)
    }
    
    func p_arrayToString(_ array: Array<Int>) -> String {
        let string = array.map(String.init).joined(separator: ",")
        return string
    }
    
    func p_stringToArray(_ string: String) -> [Int] {
        guard string.mst_charLength != 0 else {
            return []
        }
        let array = string.components(separatedBy: ",")

        let tArr = array.map(Int.init)
        return tArr as! Array<Int>
    }
}
