//
//  MSTTools_Log.swift
//  Reader
//
//  Created by 张宇豪 on 2019/6/30.
//  Copyright © 2019 张宇豪. All rights reserved.
//

import UIKit

public extension MSTTools {
    class func writeLog(_ content: String) {
        let dateStr = formatTimeRightNow(formatterType: .yyyy_MM_dd)

        let timeStr = formatTimeRightNow(formatterType: .yyyy_MM_dd_HH_mm_ss_SSS)
        
        let dPath = cachePath() + "Log/"
        let path = dPath + dateStr
        
        do {
            try createDirctory(path: dPath)
        } catch {
            return
        }
        
        let tContent = "\(timeStr): \(content)\n"

        writeContentToFile(filePath: path, content: tContent)
    }
    
    class func clearLog() {
        let path = MSTTools.cachePath() + "Log"
        
        try! deleteDirectoryContents(path: path)
    }
}
