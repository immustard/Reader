//
//  ReadView.swift
//  Reader
//
//  Created by 张宇豪 on 2019/7/7.
//  Copyright © 2019 张宇豪. All rights reserved.
//

import UIKit

class ReadView: UIView {

    // MARK: - Properties
    var frameRef: CTFrame? {
        didSet {

        }
    }

    var content: String = "" {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    // MARK: - Instance Methods
    override func draw(_ rect: CGRect) {
        guard frameRef != nil else { return }
        
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.textMatrix = .identity
        ctx?.translateBy(x: 0, y: rect.height)
        ctx?.scaleBy(x: 1, y: -1)
        
        guard ctx != nil else { return }

        CTFrameDraw(frameRef!, ctx!)
    }
}
