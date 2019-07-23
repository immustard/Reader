//
//  MSTTools_File.swift
//  Reader
//
//  Created by 张宇豪 on 2019/6/29.
//  Copyright © 2019 张宇豪. All rights reserved.
//

import UIKit

public enum MSTFileError: Error {
    case notExist
}

public extension MSTTools {
    
    class func homePath() -> String {
        return NSHomeDirectory()
    }
    
    class func tempPath() -> String {
        return NSTemporaryDirectory()
    }
    
    class func documentsPath() -> String {
        return NSHomeDirectory() + "/Documents/"
    }
    
    class func libraryPath() -> String {
        return NSHomeDirectory() + "/Library/"
    }
    
    class func cachePath() -> String {
        return NSHomeDirectory() + "/Caches/"
    }
    
    class func filePath(name: String) -> String {
        return documentsPath() + name
    }
    
    class func fileName(path: String) -> String {
        return path.components(separatedBy: "/").last!
    }
    
    class func fileNameWithoutSuffix(path: String) -> String? {
        let arr = path.components(separatedBy: "/")
        
        return arr.last?.components(separatedBy: ".").first
    }
    
}

public extension MSTTools {
    class func fileLengh(path: String) -> Int64 {
        guard fileExist(path: path) else { return -1 }
        
        do {
            let length = try FileManager.default.attributesOfItem(atPath: path)[.size] as! Int64
            
            return length
        } catch {
            return -1
        }
    }
    
    class func fileSize(path: String) throws -> String? {
        guard fileExist(path: path) else { return nil }
        
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
        
        return ByteCountFormatter.string(fromByteCount: Int64(data.count), countStyle: .file)
    }
    
}

public extension MSTTools {
    
    class func fileExist(path: String) -> Bool {
        return FileManager.default.fileExists(atPath: path)
    }
    
    class func DirctoryExist(path: String) -> Bool {
        var isDirectory: ObjCBool = true
        
        return FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
    }
    
}

public extension MSTTools {
    
    class func createFile(path: String) -> Bool {
        if fileExist(path: path) { return true }
        
        return FileManager.default.createFile(atPath: path, contents: nil, attributes: nil)
    }
    
    class func createDirctory(path: String) throws {
        if DirctoryExist(path: path) { return }
        
        try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
    }
    
    class func deleteFile(path: String) throws {
        try FileManager.default.removeItem(atPath: path)
    }
    
    class func deleteDirectory(path: String) throws {
        try FileManager.default.removeItem(atPath: path)
    }
    
    class func deleteDirectoryContents(path: String) throws {
        var tmpPath = path
        
        if !path.hasSuffix("/") {
            tmpPath += "/"
        }
        
        let arr = try FileManager.default.contentsOfDirectory(atPath: path)
        
        try arr.enumerated().forEach { (fileName) in
            try deleteFile(path: tmpPath+fileName.element)
        }
    }
    
    class func renameFile(oldPath: String, newPath: String) throws {
        guard fileExist(path: oldPath) else {
            throw MSTFileError.notExist
        }
        
        if fileExist(path: newPath) {
            try deleteFile(path: newPath)
        }
        
        try FileManager.default.moveItem(atPath: oldPath, toPath: newPath)
    }
}

public extension MSTTools {
    
    class func writeContentToFile(filePath path: String, content: String) {
        _ = createFile(path: path)
        
        let array = [UInt8](content.utf8)
        
        let os = OutputStream(toFileAtPath: path, append: true)
        os?.open()
        os?.write(array, maxLength: array.count)
        os?.close()
    }
    
    class func loadContentFromFile(filePath path: String) -> String {
        do {
            let url = URL(fileURLWithPath: path)
            let data = try Data(contentsOf: url)
            let result = String(data: data, encoding: .utf8) ?? ""
            
            return result
        } catch {
            return ""
        }
    }
}
