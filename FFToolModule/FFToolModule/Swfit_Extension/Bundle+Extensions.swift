//
//  Bundle+Extensions.swift
//  FFToolModule
//
//  Created by apple on 16/6/29.
//  Copyright © 2017年 郑强飞. All rights reserved.
//

import Foundation

extension Bundle {

    // 计算型属性类似于函数，没有参数，有返回值
   public var namespace: String {
        return infoDictionary?["CFBundleName"] as? String ?? ""
    }
}
