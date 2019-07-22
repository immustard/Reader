//
//  RealmRecordTool.swift
//  Reader
//
//  Created by 张宇豪 on 2019/7/22.
//  Copyright © 2019 Mustard. All rights reserved.
//

import UIKit

private let _db = RealmTool.db()

// MARK: - Update
class RealmRecordTool: NSObject {
    class func updateRecord(_ record: RecordModel) {
        try! _db.write {
            _db.add(record, update: .modified)
        }
    }
}

// MARK: - Delete
extension RealmRecordTool {
    class func delete(byBookID id: Int) {
        if let r = query(byBookID: id) {
            try! _db.write {
                _db.delete(r)
            }
        }
    }
}

// MARK: - Query
extension RealmRecordTool {
    class func query(byBookID id: Int) -> RecordModel? {
        return _db.object(ofType: RecordModel.self, forPrimaryKey: id)
    }
}

