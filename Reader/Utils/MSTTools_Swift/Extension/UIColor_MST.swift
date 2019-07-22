//
//  UIColor_MST.swift
//  Reader
//
//  Created by 张宇豪 on 2019/6/28.
//  Copyright © 2019 张宇豪. All rights reserved.
//

import UIKit

public extension UIColor {
    
    static func mst_colorWithHexString(_ hexString: String) -> UIColor {
        var alpha, red, blue, green: CGFloat

        let colorString = hexString.replacingOccurrences(of: "#", with: "").uppercased()
        switch colorString.mst_charLength {
        case 3: // RGB
            alpha = 1
            red = p_colorComponent(fromStrig: colorString, start: 0, length: 1)
            green = p_colorComponent(fromStrig: colorString, start: 1, length: 1)
            blue = p_colorComponent(fromStrig: colorString, start: 2, length: 1)
        case 4: // ARGB
            alpha = p_colorComponent(fromStrig: colorString, start: 0, length: 1)
            red = p_colorComponent(fromStrig: colorString, start: 1, length: 1)
            green = p_colorComponent(fromStrig: colorString, start: 2, length: 1)
            blue = p_colorComponent(fromStrig: colorString, start: 3, length: 1)
        case 6: // RRGGBB
            alpha = 1
            red = p_colorComponent(fromStrig: colorString, start: 0, length: 2)
            green = p_colorComponent(fromStrig: colorString, start: 2, length: 2)
            blue = p_colorComponent(fromStrig: colorString, start: 4, length: 2)
        case 8: // AARRGGBB
            alpha = p_colorComponent(fromStrig: colorString, start: 0, length: 2)
            red = p_colorComponent(fromStrig: colorString, start: 2, length: 2)
            green = p_colorComponent(fromStrig: colorString, start: 4, length: 2)
            blue = p_colorComponent(fromStrig: colorString, start: 6, length: 2)
        default:
            return UIColor.white
        }
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    static func mst_random() -> UIColor {
        let r: CGFloat = CGFloat(arc4random() % 255) / 255
        let g: CGFloat = CGFloat(arc4random() % 255) / 255
        let b: CGFloat = CGFloat(arc4random() % 255) / 255
        
        return UIColor(red: r, green: g, blue: b, alpha: 1)
    }

    // MARK - Private Methods
    private static func p_colorComponent(fromStrig string: String, start: Int, length: Int) -> CGFloat {
        let substring = string.mst_substring(range: Range(start...start+length))!
        let fullHex = length == 2 ? substring : "\(substring)\(substring)"
        
        var hexComponent: UInt32 = 0
        Scanner(string: fullHex).scanHexInt32(&hexComponent)

        return CGFloat(hexComponent)/255
    }
    
}
