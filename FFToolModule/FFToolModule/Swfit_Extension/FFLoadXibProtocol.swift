//
//  FFLoadXibProtocol.swift
//  FFToolModule
//
//  Created by 郑强飞 on 2017/9/4.
//  Copyright © 2017年 郑强飞. All rights reserved.
//

/*
 功能：
    专门用来加载xib 的通用协议
 
 使用：
    遵守 ‘FFLoadXibProtocol’协议
    如：HomePageInLoginBottomView.ff_LoadXib()
 
 
 */

import Foundation
import UIKit

protocol FFLoadXibProtocol {
    
}

extension FFLoadXibProtocol where Self: UIView {
    ///提供加载XIB方法
    static func ff_LoadXib(xibStr: String? = nil) -> Self {
        return Bundle.main.loadNibNamed(xibStr ?? "\(self)", owner: nil, options: nil)?.last as! Self
    }
}
