//
//  RealmChapterTool.swift
//  Reader
//
//  Created by 张宇豪 on 2019/7/16.
//  Copyright © 2019 Mustard. All rights reserved.
//

import RealmSwift

private let _db = RealmTool.db()

// MARK: - Insert
class RealmChapterTool: NSObject {
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

// MARK: - Delete
extension RealmChapterTool {
    class func delete(byBookID id: Int) {
        let list = query(byBookID: id)
        
        try! _db.write {
            _db.delete(list)
        }
    }
}

// MARK: - Update
extension RealmChapterTool {
    class func updatePageCount(_ pageCount: String, bookID: Int, idx: Int) {
        try! _db.write {
            let list = _db.objects(ChapterModel.self).filter("bookID = \(bookID) AND idx = \(idx)")
            // TODO: 更新页数
        }
    }
}

extension RealmChapterTool {
    // MARK: - Query
    class func query(byBookID id: Int) -> Results<ChapterModel> {
        let list = _db.objects(ChapterModel.self).filter("bookID = \(id)")
        
        return list
    }
    
    class func query(byBookID bookID: Int, chapterID: Int) -> ChapterModel? {
        let list = _db.objects(ChapterModel.self).filter("bookID = \(bookID) AND idx = \(chapterID)")
    
        return list.first
    }
}
