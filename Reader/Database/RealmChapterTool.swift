//
//  RealmChapterTool.swift
//  Reader
//
//  Created by 张宇豪 on 2019/7/16.
//  Copyright © 2019 Mustard. All rights reserved.
//

import RealmSwift

private let _db = RealmTool.db()

class RealmChapterTool: NSObject {
    // MARK: - Insert
    class func insert(_ chapter: ChapterModel) {
        try! _db.write {
            _db.add(chapter)
        }
    }

    class func insert(_ chapters: Array<ChapterModel>) {
        try! _db.write {
            _db.add(chapters)
        }
    }
}

extension RealmChapterTool {
    // MARK: - Update
    class func updatePageCount(_ pageCount: String, bookID: Int, idx: Int) {
        try! _db.write {
            let list = _db.objects(ChapterModel.self).filter("bookID = \(bookID) AND idx = \(idx)")
            // TODO: 更新页数
        }
    }
}

extension RealmChapterTool {
    // MARK: - Query
    class func query(byBookID id: String) -> Results<ChapterModel> {
        let list = _db.objects(ChapterModel.self).filter("bookID = '\(id)'")
        
        return list
    }
}
