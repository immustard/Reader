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

            let path = ReadUtilities.save(content, bookName: bookName!)
            
            let bookID = BookModel.incrementalID()
            
            ReadUtilities.separateChaters(content: content, bookID: bookID) { array in
                RealmChapterTool.insert(array)
                
                let book = BookModel()
                book.id = bookID
                book.title = "mdjyml"
                book.resource = url.path
                book.content = content
                book.chapterArray = array
                book.content = path
                
                RealmBookTool.insert(book)
                
                completion(book)
            }

        }
    }
    
    /// 解析章节, bookID可不填, 不填时为-1
    static func separateChaters(content: String, bookID: Int, completion:((Array<ChapterModel>) -> Void)?) {
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
    
    /// 获取展示区域
    static func displayRect() -> CGRect {
        let left = ReadConfig.default.leftSpacing
        let top = ReadConfig.default.topSpacing
        let width = kScreenWidth-ReadConfig.default.leftSpacing-ReadConfig.default.rightSpacing
        let height = kScreenHeight-ReadConfig.default.topSpacing-ReadConfig.default.bottomSpacing
        
        return CGRect(x: left, y: top, width: width, height: height)
    }
}

extension ReadUtilities {
    class func bookFolder(_ bookName: String) -> String? {
        do {
            let path = MSTTools.cachePath() + "Books/" + bookName
            try MSTTools.createDirctory(path: path)

            return path
        } catch {
            print("Get book's(\(bookName)) folder error: \(error)")
            return nil
        }
    }
    
    /// 缓存书籍
    class func save(_ content: String, bookName name: String) -> String {
        if let path = bookFolder(name) {
            let contentPath = path+"/content.txt"
            let size = MSTTools.fileLengh(path: contentPath)

            // 判断文件大小是否和文字内容一致
            if size < content.mst_byteLength {
                do {
                    try MSTTools.deleteFile(path: contentPath)
                } catch {}
                
                MSTTools.writeContentToFile(filePath: contentPath, content: content)
            }
            
            return "/Caches/Books/\(name)/content.txt"
        } else {
            return ""
        }
    }
    
    /// 读取书籍
    class func load(_ bookName: String) -> String {
        if let path = bookFolder(bookName) {
            let contentPath = path+"/content.txt"

            return MSTTools.loadContentFromFile(filePath: contentPath)
        } else {
            return ""
        }

    }
}
