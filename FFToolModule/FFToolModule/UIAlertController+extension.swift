//
//  UIAlertController+extension.swift
//  FFToolModule
//
//  Created by 郑强飞 on 2017/4/21.
//  Copyright © 2017年 郑强飞. All rights reserved.
//

import Foundation
import UIKit

public enum CommonUIAlertControllerStyle : Int {
    case alert
    case actionSheet
}

extension UIAlertController {
    
    // MARK: - alert 弹窗模态
    /**
     弹出 是\否   如果ok_name \ cancel_name = nil 则只弹出一个 UIAlertAction
     
     - parameter vc:              self
     - parameter title:           标题
     - parameter message:         消息
     - parameter ok_name:         确定名称
     - parameter cancel_name:     取消名称
     - parameter style:           样式---0底部弹出  1Show弹出
     - parameter OK_Callback:     确定必包回调
     - parameter Cancel_Callback: 取消必包回调
     */
    @discardableResult
    static public func present(_ vc: UIViewController,title: String,message: String,ok_name: String?,cancel_name: String?,style: CommonUIAlertControllerStyle, OK_Callback: (() -> Void)?, Cancel_Callback: (() -> Void)?) -> UIAlertController {
        
        var Method:UIAlertControllerStyle
        switch (style) {
        case .alert: Method = UIAlertControllerStyle.alert;
            break
        case .actionSheet: Method = UIAlertControllerStyle.actionSheet;
            break
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: Method)
        
        if(ok_name != nil) {
            let okAction = UIAlertAction(title: ok_name, style: UIAlertActionStyle.default) { (UIAlertAction) in
                OK_Callback!()
            }
            alertController.addAction(okAction)
        }
        if(cancel_name != nil) {
            let cancelAction = UIAlertAction(title: cancel_name, style: UIAlertActionStyle.cancel){ (UIAlertAction) in
                Cancel_Callback!()
            }
            alertController.addAction(cancelAction)
        }
        vc.present(alertController, animated: true, completion: nil)
        return alertController
    }
    
    public var textAlignment: NSTextAlignment {
        set {
            let messageParentView = self.getParentViewOfTitleAndMessageFromView(view: self.view)
            if (messageParentView != nil) && (messageParentView?.subviews.count)! > 1 {
                let messageLb = messageParentView?.subviews[1] as? UILabel
                messageLb?.textAlignment = textAlignment
            }
        }
        get {
            let messageParentView = self.getParentViewOfTitleAndMessageFromView(view: self.view)
            if (messageParentView != nil) && (messageParentView?.subviews.count)! > 1 {
                let messageLb = messageParentView?.subviews[1] as? UILabel
                return (messageLb?.textAlignment)!
            }
            return .center
        }
    }
    
    private func getParentViewOfTitleAndMessageFromView(view: UIView) -> UIView? {
        for subView in view.subviews {
            if subView.isKind(of: UILabel.self) {
                return view
            } else {
                let resultV: UIView? = self.getParentViewOfTitleAndMessageFromView(view: subView)
                if (resultV != nil) {
                    return resultV
                }
            }
        }
        return nil
    }
}
