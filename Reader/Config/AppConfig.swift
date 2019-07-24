//
//  AppConfig.swift
//  Reader
//
//  Created by 张宇豪 on 2019/7/18.
//  Copyright © 2019 Mustard. All rights reserved.
//

import UIKit

class AppConfig: NSObject {
    static let `default` = AppConfig()
    
    func themeColor() -> UIColor {
        return UIColor.mst_colorWithHexString("#99CCCD")
    }
}
