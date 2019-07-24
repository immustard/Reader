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
        
        MSTTools.doTaskAsynInMain {
            tool.ad = UIApplication.shared.delegate
        }
        
        return tool
    }()
    
    var ad: UIApplicationDelegate?
}
