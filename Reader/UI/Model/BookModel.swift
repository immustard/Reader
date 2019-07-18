//
//  BookModel.swift
//  Reader
//
//  Created by 张宇豪 on 2019/7/16.
//  Copyright © 2019 Mustard. All rights reserved.
//

import UIKit
import RealmSwift

class BookModel: Object, NSCopying {

    // MARK: - Properties
    /// 书目id
    @objc dynamic var id = 0

    /// 资源地址
    @objc dynamic var resource: String = ""
    /// 书名
    @objc dynamic var title: String = ""
    /// 文字内容
    @objc dynamic var content: String = ""
    /// 缓存地址
    @objc dynamic var cachePath: String = ""
    /// 类型
    @objc dynamic var readType: Int = ReadTypeUnkown
    /// 章节(realm)
    private let chapters = List<ChapterModel>()
    /// 章节
    var chapterArray: Array<ChapterModel> {
        get {
            return Array(chapters)
        }
        set {
            chapters.removeAll()
            chapters.append(objectsIn: newValue)
        }
    }
    
    /// 最后一次打开时间
    @objc dynamic var lastOpenTime: String = "0"
    
    override var description: String {
        return "book id: \(id)" + ", title: \(title)" + ", contentLength: \(content.mst_charLength)" + ", chapterCount: \(chapters.count)" + ", type: \(readType)"
    }
    
    //重写 Object.primaryKey() 可以设置模型的主键。
    //声明主键之后，对象将被允许查询，更新速度更加高效，并且要求每个对象保持唯一性。
    //一旦带有主键的对象被添加到 Realm 之后，该对象的主键将不可修改。
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["content"]
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
        ReadUtilities.separateChaters(content: content, bookID: -1, bookName: nil) { (array) in
            self.chapters.append(objectsIn: array)
        }
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let obj = type(of: self).init()
        obj.content = content
        obj.id = id
        obj.resource = resource
        obj.title = title
        obj.chapterArray = chapterArray
        obj.readType = readType
        
        return obj
    }
}
