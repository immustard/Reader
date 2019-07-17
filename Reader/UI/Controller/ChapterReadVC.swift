
//
//  ChapterReadVC.swift
//  Reader
//
//  Created by 张宇豪 on 2019/7/7.
//  Copyright © 2019 张宇豪. All rights reserved.
//

import UIKit

class ChapterReadVC: BaseViewController {
    // MARK: - Properties
    var readView: ReadView!
    
    // MARK: - Instance Methods
    override func initView() {
        super.initView()
        readView = ReadView(frame: self.view.frame)
        
        view.addSubview(readView)
    
        let url = Bundle.main.url(forResource: "mdjyml", withExtension: "txt")!
        
        ReadUtilities.localBookModel(byURL: url) { (book) in
            if let chapter = book.chapterArray.first {
                self.readView.frameRef = ReadParser.parseContent(content: chapter.string(ofPage: 0), bounds: ReadUtilities.displayRect())
            }
        }
    }
}
