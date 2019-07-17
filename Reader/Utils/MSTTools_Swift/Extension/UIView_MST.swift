//
//  UIView_MST.swift
//  Reader
//
//  Created by 张宇豪 on 2019/6/27.
//  Copyright © 2019 张宇豪. All rights reserved.
//

import UIKit

public extension UIView {
    
    // MARK: - Frame
    var mst_top: CGFloat {
        get {
            return frame.minY
        }
        set {
            frame.origin.y = newValue
        }
    }
    
    var mst_left: CGFloat {
        get {
            return frame.minX
        }
        set {
            frame.origin.x = newValue
        }
    }
    
    var mst_bottom: CGFloat {
        get {
            return frame.maxY
        }
        set {
            let height = mst_height
            frame.origin.y = newValue - height
        }
    }
    
    var mst_right: CGFloat {
        get {
            return frame.maxX
        }
        set {
            let tWidth = mst_width
            frame.origin.x = newValue - tWidth
        }
    }
    
    var mst_width: CGFloat {
        get {
            return frame.width
        }
        set {
            frame.size.width = newValue
        }
    }
    
    var mst_height: CGFloat {
        get {
            return frame.height
        }
        set {
            frame.size.height = newValue
        }
    }
    
    var mst_centerX: CGFloat {
        get {
            return frame.minX
        }
        set {
            let width = mst_width
            self.frame.origin.x = newValue - width/2
        }
    }
    
    var mst_centerY: CGFloat {
        get {
            return frame.midY
        }
        set {
            let height = mst_height
            frame.origin.y = newValue - height/2
        }
    }
    
    var mst_center: CGPoint {
        get {
            return center
        }
        set {
            mst_centerX = newValue.x
            mst_centerY = newValue.y
        }
    }
    
    var mst_origin: CGPoint {
        get {
            return frame.origin
        }
        set {
            mst_left = newValue.x
            mst_top = newValue.y
        }
    }
    
    var mst_size: CGSize {
        get {
            return frame.size
        }
        set {
            mst_width = newValue.width
            mst_height = newValue.height
        }
    }
    
    // MARK: - SubView
    ///  根据tag得到子视图
    func mst_subview(tag: Int) -> UIView? {
        return viewWithTag(tag)
    }
    
    /// 删除所有子视图
    func mst_removeAllSubviews() {
        while subviews.count > 0 {
            let subview = subviews.first
            subview?.removeFromSuperview()
        }
    }
    
    /// 根据tag删除子视图
    func mst_removeSubview(tag: Int) {
        guard tag != 0 else { return }
        
        let view = mst_subview(tag: tag)
        view?.removeFromSuperview()
    }
    
    /// 根据tag删除多个子视图
    func mst_removeSubviews(tags: Array<Int>) {
        for tag in tags {
            mst_removeSubview(tag: tag)
        }
    }
    
    /// 删除比该tag小的子视图
    func mst_removeSubview(lessThan tag: Int) {
        var views: Array<UIView> = []
        for view in subviews {
            if view.tag > 0 && view.tag < tag {
                views.append(view)
            }
        }
        
        p_removeSubviews(views)
    }
    
    /// 删除比该tag大的子视图
    func mst_removeSubview(greaterThan tag: Int) {
        var views: Array<UIView> = []
        for view in subviews {
            if view.tag > 0 && view.tag > tag {
                views.append(view)
            }
        }
        
        p_removeSubviews(views)
    }
    
    private func p_removeSubviews(_ views: Array<UIView>) {
        for view in views {
            view.removeFromSuperview()
        }
    }

    /// MARK: - Controller
    /// 得到该视图所在的视图控制器
    var mst_responderViewController: UIViewController? {
        for view in sequence(first: superview, next: { $0?.superview }) {
            if let responder = view?.next {
                if responder.isKind(of: UIViewController.self){
                    return responder as? UIViewController
                }
            }
        }
        return nil
    }
    
    /// MARK: - Draw Rect
    /// 设置圆形
    func mst_circular() {
        layoutIfNeeded()
        
        let size = min(mst_width, mst_height)
        mst_cornerRadius(size/2)
    }
    
    /// 设置圆角
    func mst_cornerRadius(_ radius: CGFloat) {
        layer.masksToBounds = true
        layer.cornerRadius = radius
    }
    
    /// 设置圆角线框
    func mst_cornerRadius(_ radius: CGFloat, lineWidth: CGFloat, lineColor: UIColor) {
        mst_cornerRadius(radius)
        layer.borderColor = lineColor.cgColor
        layer.borderWidth = lineWidth
    }

    /// 设置某几个角为圆角
    func mst_corners(_ corners: UIRectCorner, cornerRadius radius: CGFloat) {
        let maskPath = UIBezierPath.init(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize.init(width: radius, height: radius))
        let maskLayer = CAShapeLayer.init()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        
        layer.mask = maskLayer
    }
    
    /// 添加阴影
    func mst_addShadow(color: UIColor, shadowOffset offset: CGSize, shadowOpacity opacity: Float) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.masksToBounds = false
    }
    
    /// MARK: - Gesture
    /// 添加单击手势
    func mst_addTapGesture(target: Any?, action: Selector?) -> UITapGestureRecognizer {
        let tap = UITapGestureRecognizer.init(target: target, action: action)
        addGestureRecognizer(tap)
        
        return tap
    }
}
