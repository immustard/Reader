//
//  BookModel.swift
//  Reader
//
//  Created by 张宇豪 on 2019/7/16.
//  Copyright © 2019 Mustard. All rights reserved.
//

import UIKit
import RealmSwift

class BookModel: Object {
    // MARK: - Properties

    @objc dynamic var id = 0
    
    @objc dynamic var resource: String = ""
    
    @objc dynamic var title: String = ""

    @objc dynamic var content: String = ""
    
    @objc dynamic var readType: Int = ReadTypeUnkown
    
    override var description: String {
        return "id: \(id)" + "\ntitle: \(title)" + "\ncontentLength: \(content.mst_charLength)" + "\ntype: \(readType)"
    }

    var chapterArray: Array<ChapterModel> = [] {
        didSet {
            chapters.removeAll()
            for model in self.chapterArray {
                chapters.append(model)
            }
        }
    }
    
    let chapters = List<ChapterModel>()
    
    //重写 Object.primaryKey() 可以设置模型的主键。
    //声明主键之后，对象将被允许查询，更新速度更加高效，并且要求每个对象保持唯一性。
    //一旦带有主键的对象被添加到 Realm 之后，该对象的主键将不可修改。
    override static func primaryKey() -> String? {
        return "id"
    }
    
    class func incrementalID() -> Int {
        let realm = RealmTool.db()
        let bookNext = realm.objects(BookModel.self).sorted(byKeyPath: "id")
        
        if bookNext.count > 0 {
            let valor = bookNext.last!.id
            return valor + 1
        } else {
            return 1
        }
    }
}

extension BookModel {
    // MARK: - Initial Methods
    convenience init(_ content: String) {
        self.init()
        
        readType = ReadTypeTxt
        ReadUtilities.separateChaters(content: content, bookID: -1) { (array) in
            self.chapterArray = array
        }
    }
}
