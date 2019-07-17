//
//  String_MST.swift
//  Reader
//
//  Created by 张宇豪 on 2019/6/28.
//  Copyright © 2019 张宇豪. All rights reserved.
//

import Foundation

public extension String {
    
    var mst_byteLength: Int {
        return lengthOfBytes(using: .utf8)
    }
    
    var mst_charLength: Int {
        return utf16.count
    }
    
    func mst_substring(startIndex : Int, endIndex : Int) -> String? {
        guard endIndex >= startIndex else { return nil }
        guard endIndex <= mst_charLength else { return nil }
        
        let tStr = NSString(string: self)
        
        let string = tStr.substring(with: NSRange(location: startIndex, length: endIndex-startIndex))
        
        return string
    }
    
    func mst_substring(range: Range<Int>) -> String? {
        return mst_substring(startIndex: range.lowerBound, endIndex: range.upperBound-1)
    }
    
    func mst_substring(range: NSRange) -> String? {
        guard mst_charLength > range.location+range.length else {
            return nil
        }

        let tStr = NSString(string: self)

        return tStr.substring(with: range)
    }

    /// 将阿拉伯数字转为中文数字
    ///
    /// - Parameter number: 阿拉伯数字
    /// - Returns: 中文数字 
    func mst_convertNumberFromArabicToChinese(_ number: Double) -> String? {
        let formatter = NumberFormatter.init()
        formatter.numberStyle = .spellOut
        
        let string: String? = formatter.string(from: NSNumber.init(value: number))
        
        return string
    }
    
}

