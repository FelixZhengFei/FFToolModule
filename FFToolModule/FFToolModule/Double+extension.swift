//
//  Double+extension.swift
//  FFToolModule
//
//  Created by 郑强飞 on 2017/4/19.
//  Copyright © 2017年 郑强飞. All rights reserved.
//

import Foundation

extension Double {
    
    // MARK: - 用法 let myDouble = 1.234567  println(myDouble.format(".2") .2代表留2位小数点
    public func format(_ f: String) -> String {
        return NSString(format: "%\(f)f" as NSString, self) as String
    }
    
    //MARK:金额格式化
    public func toBalanceFormat() -> String {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        return nf.string(from: NSNumber(value: self))!
    }
    
    //MARK:大数字格式化
    public func toBigString(decimal: Int = 2) -> String {
        if self < 10000 {
            return String(self)
        } else if self <= 10000*10000 {
            return String(format: "%.\(decimal)f", self/10000) + "万"
        } else {
            return String(format: "%.\(decimal)f", self/(10000*10000)) + "亿"
        }
    }
}
