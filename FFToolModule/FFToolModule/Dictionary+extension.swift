//
//  Dictionary+extension.swift
//  FFToolModule
//
//  Created by 郑强飞 on 2017/4/19.
//  Copyright © 2017年 郑强飞. All rights reserved.

import Foundation

extension Dictionary {
    
    // MARK: - 字典转换字符串
    public func toString() -> String? {
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
            return NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
        } catch {
            return nil
        }
    }
}
