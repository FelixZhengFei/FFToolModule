//
//  UIButton+extension.swift
//  FFToolModule
//
//  Created by 郑强飞 on 2017/4/19.
//  Copyright © 2017年 郑强飞. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    private struct AssociatedKeys {
        static var buttonTapTag = "buttonTapTag"
    }
    
    fileprivate var buttonTapBlock: () -> Void {
        get {
            let tempButtonTapBlock = objc_getAssociatedObject(self, &AssociatedKeys.buttonTapTag)
            return tempButtonTapBlock! as! () -> Void
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.buttonTapTag, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    // MARK: - 点击事件回调
    public override func handleTap(_ buttonTapBlock:@escaping () -> Void) {
        self.buttonTapBlock = buttonTapBlock
        self.addTarget(self, action: #selector(buttonClickedAction), for: .touchUpInside)
    }
    
    func buttonClickedAction() {
        self.buttonTapBlock()
    }
    
}
