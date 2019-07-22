//
//  RealmBookTool.swift
//  Reader
//
//  Created by 张宇豪 on 2019/7/16.
//  Copyright © 2019 Mustard. All rights reserved.
//

import RealmSwift

private let _db = RealmTool.db()

// MARK: - Insert
class RealmBookTool: NSObject {
    class func insert(_ book: BookModel) {
        try! _db.write {
            _db.add(book)
        }
    }
}

// MARK: - Update
extension RealmBookTool {
    
}

// MARK: - Delete
extension RealmBookTool {
    class func delete(byID id: Int) {
        if let book = query(byID: id) {
            try! _db.write {
                _db.delete(book)
            }
            
            // 删除对应章节
            RealmChapterTool.delete(byBookID: id)
            // 删除对应阅读记录
            RealmRecordTool.delete(byBookID: id)
        }
    }
    
    class func deleteAll() {
        let list = queryAll()
        
        for book in list {
            RealmBookTool.delete(byID: book.id)
        }
    }
    
    
}

// MARK: - Query
extension RealmBookTool {
    class func queryAll() -> Array<BookModel> {
        let list = _db.objects(BookModel.self).sorted(byKeyPath: "lastOpenTime", ascending: false)
        
        var books: Array<BookModel> = []

        for book in list {
            book.content = MSTTools.loadContentFromFile(filePath: MSTTools.homePath() + book.cachePath)

            books.append(p_loadDetails(book))
        }
        return books
    }
    
    class func query(byResource resource: String) -> BookModel? {
        let list = _db.objects(BookModel.self).filter("resource = '\(resource)'")

        if let model = list.first {
            let filePath = MSTTools.homePath() + model.cachePath
            model.content = MSTTools.loadContentFromFile(filePath: filePath)
            
            return p_loadDetails(model)
        } else {
            return nil
        }
    }
    
    class func query(byID id: Int) -> BookModel? {
        return _db.object(ofType: BookModel.self, forPrimaryKey: id)
    }
    
    class func queryBookName(byID id: Int) -> String? {
        return query(byID: id)?.title
    }
}

// MARK - Private Methods
extension RealmBookTool {
    private class func p_loadDetails(_ book: BookModel) -> BookModel {
        let tBook = book.copy() as! BookModel

        // 读取章节
        var arr: Array<ChapterModel> = []
        for chapter in tBook.chapterArray {
            chapter.realm?.beginWrite()
            chapter.content = MSTTools.loadContentFromFile(filePath: MSTTools.homePath() + chapter.cachePath)
            try! chapter.realm?.commitWrite()
            arr.append(chapter)
        }
        tBook.chapterArray = arr
        
        // 读取阅读记录
        if let r = RealmRecordTool.query(byBookID: tBook.id) {
            tBook.record = r
        }
        
        return tBook
    }
}
