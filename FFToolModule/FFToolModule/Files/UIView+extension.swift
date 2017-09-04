//
//  UIView+extension.swift
//  FFToolModule
//
//  Created by 郑强飞 on 2017/4/19.
//  Copyright © 2017年 郑强飞. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    // Bezier加圆角
    open func viewAddBezierCorner(cornerRadius:CGFloat) {
        let cornerSize: CGSize = CGSize(width: cornerRadius, height: cornerRadius)
        let roundingCorners: UIRectCorner = [.bottomLeft,.bottomRight,.topLeft,.topRight]
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: roundingCorners, cornerRadii: cornerSize)
        let cornerLayer = CAShapeLayer()
        cornerLayer.frame = bounds
        cornerLayer.path = path.cgPath
        
        layer.mask = cornerLayer
    }
    
    // 传统加圆角
    open func viewAddLayerCorner(cornerRadius: CGFloat) {
        layer.cornerRadius = cornerRadius;//设置那个圆角的有多圆
        layer.borderWidth = 0.5;//设置边框的宽度，当然可以不要
        layer.borderColor = UIColor.init(red: 201, green: 201, blue: 201, alpha: 1).cgColor//设置边框的颜色
        layer.masksToBounds = true;//设为NO去试试
    }
    
    private struct AssociatedKeys {
        static var tapViewTag = "tapViewTag"
        static var doubleTapViewTag = "doubleTapViewTag"
        static var tapGestureRecognizerTag = "tapGestureRecognizerTag"
        static var doubleTapGestureRecognizerTag = "doubleTapGestureRecognizerTag"
    }
    
    fileprivate var tapGestureBlock: () -> Void {
        get {
            let tapViewBlock = objc_getAssociatedObject(self, &AssociatedKeys.tapViewTag)
            return tapViewBlock! as! () -> Void
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.tapViewTag, newValue, .OBJC_ASSOCIATION_COPY)
        }
    }
    
    fileprivate var doubleTapGestureBlock: () -> Void {
        get {
            let doubleTapGestureBlock = objc_getAssociatedObject(self, &AssociatedKeys.doubleTapViewTag)
            return doubleTapGestureBlock! as! () -> Void
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.doubleTapViewTag, newValue, .OBJC_ASSOCIATION_COPY)
        }
    }
    
    fileprivate var tapGestureRecognizer: UITapGestureRecognizer? {
        get {
            let tapGestureRecognizer = objc_getAssociatedObject(self, &AssociatedKeys.tapGestureRecognizerTag)
            return tapGestureRecognizer as? UITapGestureRecognizer
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.tapGestureRecognizerTag, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    fileprivate var doubleTapGestureRecognizer: UITapGestureRecognizer? {
        get {
            let doubleTapGestureRecognizer = objc_getAssociatedObject(self, &AssociatedKeys.doubleTapGestureRecognizerTag)
            return doubleTapGestureRecognizer as? UITapGestureRecognizer
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.doubleTapGestureRecognizerTag, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    // MARK: - UIView绑定事件
    public func handleTap(_ tapGestureBlock:@escaping () -> Void) {
        self.tapGestureBlock = tapGestureBlock
        self.isUserInteractionEnabled = true
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction))
        if doubleTapGestureRecognizer != nil {
            tapGestureRecognizer?.require(toFail: doubleTapGestureRecognizer!)
        }
        self.addGestureRecognizer(tapGestureRecognizer!)
    }
    
    public func handleDoubleTap(_ doubleTapGestureBlock:@escaping () -> Void) {
        self.doubleTapGestureBlock = doubleTapGestureBlock
        self.isUserInteractionEnabled = true
        doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(doubleTapGestureAction))
        doubleTapGestureRecognizer?.numberOfTapsRequired = 2
        if tapGestureRecognizer != nil {
            tapGestureRecognizer?.require(toFail: doubleTapGestureRecognizer!)
        }
        self.addGestureRecognizer(doubleTapGestureRecognizer!)
    }
    
    @objc private func tapGestureAction() {
        self.tapGestureBlock()
    }
    
    @objc private func doubleTapGestureAction() {
        self.doubleTapGestureBlock()
    }

}

extension UIView {
    
    public var x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    
    public var y: CGFloat{
        get {
            return self.frame.origin.y
        }
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    
    /** 宽 */
    public var width: CGFloat{
        get {
            return self.frame.size.width
        }
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
    }
    
    /** 高 */
    public var height: CGFloat{
        get {
            return self.frame.size.height
        }
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
    }
    
    /** 下 */
    public var bottom: CGFloat{
        get {
            return self.frame.origin.y + self.frame.size.height
        }
        
        set {
            var frame = self.frame
            frame.origin.y = newValue - self.frame.size.height
            self.frame = frame
        }
    }
    
    /** 右 */
    public var right: CGFloat{
        get {
            return self.frame.origin.x + self.frame.size.width
        }
        
        set {
            var frame = self.frame
            frame.origin.x = newValue - self.frame.size.width
            self.frame = frame
        }
    }
    
    /** 尺寸 */
    public var size: CGSize{
        get {
            return self.frame.size
        }
        
        set {
            var frame = self.frame
            frame.size = newValue
            self.frame = frame
        }
    }
    
    /** 竖直中心对齐 */
    public var centerX: CGFloat{
        get {
            return self.center.x
        }
        
        set {
            var center = self.center
            center.x = newValue
            self.center = center
        }
    }
    
    /** 水平中心对齐 */
    public var centerY: CGFloat{
        get {
            return self.center.y
        }
        
        set {
            var center = self.center
            center.y = newValue
            self.center = center
        }
    }
    
}
