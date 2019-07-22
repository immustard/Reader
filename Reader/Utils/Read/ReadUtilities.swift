//
//  ReadUtilities.swift
//  Reader
//
//  Created by 张宇豪 on 2019/7/5.
//  Copyright © 2019 张宇豪. All rights reserved.
//

import UIKit

class ReadUtilities: NSObject {
    class func localBookModel(byURL url: URL, completion:@escaping ((BookModel) -> Void)) {
        if let model = RealmBookTool.query(byResource: url.path) {
            completion(model)
        } else {
            let content = ReadUtilities.encode(url: url)

            let bookName = MSTTools.fileNameWithoutSuffix(path: url.path)

            let bookID = BookModel.incrementalID()

            let path = ReadUtilities.save(content, bookID: bookID)
            
            separateChaters(content: content, bookID: bookID, bookName: bookName) { array in
                /// 保存章节
                RealmChapterTool.insert(array)
                
                let book = BookModel()
                book.id = bookID
                book.title = "mdjyml"
                book.resource = url.path
                book.chapterArray = array
                book.content = content
                book.cachePath = path

                /// 保存阅读记录
                RealmRecordTool.updateRecord(book.record)

                /// 保存书目
                RealmBookTool.insert(book)

                completion(book)
            }

        }
    }
    
    /// 解析章节, bookID可不填, 不填时为-1
    static func separateChaters(content: String, bookID: Int, bookName: String?, completion:((Array<ChapterModel>) -> Void)?) {
        let pattern = "第[0-9一二三四五六七八九十百千]*[章回].*"
        let tContent = NSString(string: content)

        do {
            let reg = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            
            let match = reg.matches(in: content, options: .reportCompletion, range: NSRange(location: 0, length: content.mst_charLength))

            var resultArr: Array<ChapterModel>! = []

            if match.count != 0 {

                var lastRange = NSRange(location: 0, length: 0)
                match.enumerated().forEach { (idx, result) in
                    let range = result.range
                    let location = range.location
                    
                    var cTitle = ""
                    var cContent = ""

                    if idx == 0 {
                        // 开始
                        cTitle = "开始"
                        cContent = tContent.substring(with: NSRange(location: 0, length: location))
                    }
                    
                    if idx > 0 {
                        // 中间
                        cTitle = tContent.substring(with: lastRange)
                        let len = location-lastRange.location
                        cContent = tContent.substring(with: NSRange(location: lastRange.location, length: len))
                    }
                    
                    if idx == match.count-1 {
                        // 最后
                        cTitle = tContent.substring(with: range)
                        cContent = tContent.substring(with: NSRange(location: location, length: tContent.length-location))
                    }
                    lastRange = range

                    let model = ChapterModel()
                    model.title = cTitle
                    model.content = cContent
                    model.idx = idx+1
                    model.bookID = max(0, bookID)
                    
                    if bookName != nil {
                       model.cachePath = save(cContent, chapterName: "\(idx+1)", bookID: bookID)
                    }

                    resultArr.append(model)
                }
            } else {
                let model = ChapterModel()
                model.content = content
                model.idx = 1
                
                resultArr.append(model)
            }
            
            if completion != nil {
                completion!(resultArr)
            }
        } catch {
            let model = ChapterModel()
            model.content = content
            model.idx = 1

            print("separateChaters Error: \(error)")
            
            if completion != nil {
                completion!([model])
            }
        }
    }
    
    /// 转码
    static func encode(url: URL) -> String {
        var content = ""
        let cfEncoding = CFStringEncodings.GB_18030_2000
        let encoding = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEncoding.rawValue))

        do {
            content = try String(contentsOf: url)

            return content
        } catch {
            do {
                content = try String(contentsOf: url, encoding: String.Encoding(rawValue: encoding))

                return content
            } catch {
                return content
            }
        }
    }
}

// MARK: - Book
extension ReadUtilities {
    /// 书籍目录
    class func bookFolder(_ bookID: Int) -> String? {
        do {
            let path = MSTTools.documentsPath() + "Books/\(bookID)"
            try MSTTools.createDirctory(path: path)

            return path
        } catch {
            print("Get book's(\(bookID)) folder error: \(error)")
            return nil
        }
    }
    
    /// 缓存书籍
    class func save(_ content: String, bookID id: Int) -> String {
        if let path = bookFolder(id) {
            let contentPath = path+"/content.txt"
            let size = MSTTools.fileLengh(path: contentPath)

            // 判断文件大小是否和文字内容一致
            if size < content.mst_byteLength {
                do {
                    try MSTTools.deleteFile(path: contentPath)
                } catch {}
                
                MSTTools.writeContentToFile(filePath: contentPath, content: content)
            }
            
            return "/Documents/Books/\(id)/content.txt"
        } else {
            return ""
        }
    }
    
    /// 读取书籍
    class func load(_ bookID: Int) -> String {
        if let path = bookFolder(bookID) {
            let contentPath = path+"/content.txt"

            return MSTTools.loadContentFromFile(filePath: contentPath)
        } else {
            return ""
        }

    }
}

// MARK: - Chapter
extension ReadUtilities {
    class func chapterFolder(byBookID id: Int) -> String? {
        if let bookPath = bookFolder(id) {
            let folderPath = bookPath + "/Chapters"
            
            do {
                try MSTTools.createDirctory(path: folderPath)
                
                return folderPath
            } catch {
                print("Get book(\(id)) chapter's folder error: \(error)")
                return nil
            }
        } else {
            return nil
        }
    }
    
    class func save(_ content: String, chapterName: String, bookID: Int) -> String {
        if let chapterPath = chapterFolder(byBookID: bookID) {
            let contentPath = chapterPath + "/" + chapterName + ".txt"
            let size = MSTTools.fileLengh(path: contentPath)

            // 判断文件大小是否和文字内容一致
            if size < content.mst_byteLength {
                do {
                    try MSTTools.deleteFile(path: contentPath)
                } catch {}
                
                MSTTools.writeContentToFile(filePath: contentPath, content: content)
            }
            
            return "/Documents/Books/\(bookID)/Chapters/\(chapterName).txt"
        } else {
            return ""
        }
    }
}
