//
//  RecordModel.swift
//  Reader
//
//  Created by 张宇豪 on 2019/7/22.
//  Copyright © 2019 Mustard. All rights reserved.
//

import UIKit
import RealmSwift

class RecordModel: Object {
    // MARK: - Properties
    /// 书目ID
    @objc dynamic var bookID: Int = 0
    /// 页数(realm)
    @objc dynamic private var pageIdx: Int = 0
    
    /// 章节数(realm)
    @objc dynamic private var chapterIdx: Int = 0
    
    /// 页数
    var page: Int {
        get {
            return pageIdx
        }
        set {
            try! realm?.write {
                pageIdx = newValue
            }
        }
    }
    /// 章节数
    var chapter: Int {
        get {
            return chapterIdx
        }
        set {
            try! realm?.write {
                chapterIdx = newValue
            }
        }
    }
    
    /// 总章节数
    @objc dynamic var totalChapter: Int = 0

    /// 记录的章节
    var chapterModel: ChapterModel? {
        return RealmChapterTool.query(byBookID: bookID, chapterID: chapter)
    }
    
    override var description: String {
        return "record bookID: \(bookID)" + ", chapter: \(chapter)" + ", page: \(page)"
    }
    
    override static func primaryKey() -> String? {
        return "bookID"
    }
}
