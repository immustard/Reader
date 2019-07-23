//
//  AppDelegate.swift
//  Reader
//
//  Created by 张宇豪 on 2019/7/16.
//  Copyright © 2019 Mustard. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let rect = UIScreen.main.bounds
        window = UIWindow()
        window?.frame = CGRect(x: 0, y: 0, width: rect.width+0.000001, height: rect.height+0.000001)
        
        let rootNav = NavigationController(rootViewController: ViewController())
        window?.rootViewController = rootNav
        window?.makeKeyAndVisible()

        RealmTool.customInitialize()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        ReadUtilities.localBookModel(byURL: url, completion: nil)
        
        return true
    }
}

