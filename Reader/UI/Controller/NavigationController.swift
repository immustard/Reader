//
//  NavigationController.swift
//  Reader
//
//  Created by 张宇豪 on 2019/7/18.
//  Copyright © 2019 Mustard. All rights reserved.
//

import UIKit

class NavigationController: RTRootNavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        customNavigationBarStyle()
    }
    
    func customNavigationBarStyle() {
        UINavigationBar.appearance().tintColor = kColor333
        UINavigationBar.appearance().barTintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: kColor333]
        UINavigationBar.appearance().isTranslucent = false
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        // 如果push进来的不是第一个控制器(栈底控制器)
        if children.count > 0 {
            // 隐藏tabBar
            viewController.hidesBottomBarWhenPushed = true
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
    override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }
}
