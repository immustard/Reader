//
//  RealmBookTool.swift
//  Reader
//
//  Created by 张宇豪 on 2019/7/16.
//  Copyright © 2019 Mustard. All rights reserved.
//

import RealmSwift

private let _db = RealmTool.db()

class RealmBookTool: NSObject {
    // MARK: - Insert
    class func insert(_ book: BookModel) {
        try! _db.write {
            _db.add(book)
        }
    }
}

extension RealmBookTool {
    // MARK: - Query
    class func queryAll() -> Array<BookModel> {
        let list = _db.objects(BookModel.self)
        
        var books: Array<BookModel> = []

        for book in list {
            book.content = MSTTools.loadContentFromFile(filePath: MSTTools.homePath() + book.cachePath)

            books.append(book)
        }
        return books
    }
    
    class func query(byResource resource: String) -> BookModel? {
        let list = _db.objects(BookModel.self)
//            .filter("resource = '\(resource)'")

        if let model = list.first {
            let filePath = MSTTools.homePath() + model.cachePath
            model.content = MSTTools.loadContentFromFile(filePath: filePath)
            
            return p_loadChapters(model)
        } else {
            return nil
        }
    }
    
    class func queryBookName(byID id: Int) -> String? {
        return _db.object(ofType: BookModel.self, forPrimaryKey: id)?.title
    }
}

extension RealmBookTool {
    // MARK - Private Methods
    private class func p_loadChapters(_ book: BookModel) -> BookModel {
        let tBook = book.copy() as! BookModel

        var arr: Array<ChapterModel> = []
        for chapter in tBook.chapterArray {
            chapter.realm?.beginWrite()
            chapter.content = MSTTools.loadContentFromFile(filePath: MSTTools.homePath() + chapter.cachePath)
            try! chapter.realm?.commitWrite()
            arr.append(chapter)
        }
        tBook.chapterArray = arr
        
        return tBook
    }
}
