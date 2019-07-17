//
//  ViewController.swift
//  Reader
//
//  Created by 张宇豪 on 2019/7/16.
//  Copyright © 2019 Mustard. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try FileManager.default.removeItem(at: Realm.Configuration.defaultConfiguration.fileURL!)
        } catch {}
        
        let url = Bundle.main.url(forResource: "mdjyml", withExtension: "txt")!
        
        ReadUtilities.localBookModel(byURL: url) { (book) in
            print(book)
        }
    }


}

