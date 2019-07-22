//
//  ReadImplVC.swift
//  Reader
//
//  Created by 张宇豪 on 2019/7/21.
//  Copyright © 2019 Mustard. All rights reserved.
//

import UIKit

class ReadImplVC: BaseViewController {

    // MARK: - Properties
    var content: String = ""
    
    var page: Int = 0
    var chapter: Int = 0
    
    var recordModel: RecordModel?
    
    private lazy var _readView: ReadView = {
        let view = ReadView(frame: ReadConfig.default.displayRect)
        view.frameRef = ReadParser.parseContent(content: self.content, bounds: view.bounds)
        view.content = self.content
        
        return view
    }()
    
    // MARK: - Instance Methods
    override func initView() {
        super.initView()
        
        view.addSubview(_readView)
    }
}
