//
//  MSTTools.swift
//  Reader
//
//  Created by 张宇豪 on 2019/6/29.
//  Copyright © 2019 张宇豪. All rights reserved.
//

import UIKit

public class MSTTools: NSObject {
    static let shared: MSTTools = {
        let tool = MSTTools()
        
        DispatchQueue.main.async {
            tool._ad = UIApplication.shared.delegate
        }
        
        return tool
    }()
    
    private var _ad: UIApplicationDelegate?

    class func isIphoneX() -> Bool {
        return MSTTools.shared.p_isIphoneX()
    }
    
    private func p_isIphoneX() -> Bool {
        return _ad?.window??.safeAreaInsets != UIEdgeInsets.zero
    }
}
