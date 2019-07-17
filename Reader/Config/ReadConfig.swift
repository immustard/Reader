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
    
    // MARK: - Initial Methods
    private override init() {
        super.init()
    }
}
