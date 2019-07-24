//
//  MSTTools_Device.swift
//  Reader
//
//  Created by 张宇豪 on 2019/7/19.
//  Copyright © 2019 Mustard. All rights reserved.
//

import UIKit

public extension MSTTools {
    var deviceName: String {
        return UIDevice.current.name
    }
    
    var systemVersion: String {
        return UIDevice.current.systemVersion
    }
    
    // MARK: - Class Methods
    class func isIphoneX() -> Bool {
        return MSTTools.shared.p_isIphoneX()
    }
    
    // MARK - Private Methods
    private func p_isIphoneX() -> Bool {
        if #available(iOS 11.0, *) {
            return self.ad?.window??.safeAreaInsets != UIEdgeInsets.zero
        } else {
            return false
        }
    }
}
