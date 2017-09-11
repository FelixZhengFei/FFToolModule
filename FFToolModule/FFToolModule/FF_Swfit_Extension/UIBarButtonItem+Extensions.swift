//
//  UIBarButtonItem+Extensions.swift
//  FFToolModule
//
//  Created by apple on 16/6/29.
//  Copyright © 2017年 郑强飞. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    /// 创建 UIBarButtonItem
    ///
    /// - parameter title:    title
    /// - parameter fontSize: fontSize，默认 16 号
    /// - parameter target:   target
    /// - parameter action:   action
    /// - parameter isBack:   是否是返回按钮，如果是加上箭头
    ///
    /// - returns: UIBarButtonItem
    public convenience init(title: String, fontSize: CGFloat = 16,textColor:UIColor = UIColor.cz_color(withRed: 66, green: 66, blue: 66), target: AnyObject?, action: Selector, isBack: Bool = false) {
        let btn: UIButton = UIButton.cz_textButton(title, fontSize: fontSize, normalColor:textColor, highlightedColor: UIColor.black)
        
        
        if isBack {
            let imageName = "Back-icon_press"
            
            btn.setImage(UIImage(named: imageName), for: UIControlState(rawValue: 0))
            btn.setImage(UIImage(named: "Back-icon"), for: .highlighted)
            
            btn.sizeToFit()
        }
        
        btn.addTarget(target, action: action, for: .touchUpInside)
        
        // self.init 实例化 UIBarButtonItem
        self.init(customView: btn)
    }
    
   public convenience init(imageName: String, target: AnyObject?, action: Selector) {
        let btn : UIButton = UIButton(type: .custom)
        
            btn.setImage(UIImage(named: imageName), for: UIControlState(rawValue: 0))
            btn.setImage(UIImage(named: imageName), for: .highlighted)
            btn.sizeToFit()
        btn.addTarget(target, action: action, for: .touchUpInside)
        
        // self.init 实例化 UIBarButtonItem
        self.init(customView: btn)
    }
}
