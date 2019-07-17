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
            let model = p_transformContent(book)

            books.append(model)
        }
        return books
    }
    
    class func query(byResource resource: String) -> BookModel? {
        let list = _db.objects(BookModel.self)

        if let model = list.first {
            return p_transformContent(model)
        } else {
            return nil
        }
    }
}

extension RealmBookTool {
    // MARK - Private Methods
    private class func p_transformContent(_ book: BookModel) -> BookModel {
        let model = BookModel()
        model.id = book.id
        model.title = book.title
        model.content = MSTTools.loadContentFromFile(filePath: MSTTools.homePath() + book.content)
        model.resource = book.resource
        model.readType = book.readType
        
        return model
    }
}
