//
//  Int+extension.swift
//  FFToolModule
//
//  Created by 郑强飞 on 2017/5/3.
//  Copyright © 2017年 郑强飞. All rights reserved.
//

import Foundation

extension Int {
    
    //MARK:金额格式化
    public func toBalanceFormat() -> String {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        return nf.string(from: NSNumber(value: self))!
    }
    
    //MARK:金额格式化 12.00
    public func toRMBBalanceFormat() -> String {
        let nf = NumberFormatter()
        nf.numberStyle = .currency
        nf.currencySymbol = "￥"
        return nf.string(from: NSNumber(value: self))!
    }
    
    //MARK:大数字格式化
    public func toBigString() -> String {
        if self < 10000 {
            return String(self)
        } else if self <= 10000*10000 {
            return "\(self/10000)万"
        } else {
            return "\(self/(10000*10000))亿"
        }
    }
    
    //MARK:字节格式化
    public func toByteString() -> String {
        if self < 1024 {
            return String(self) + "B"
        } else if self < 1024 * 1024 {
            return String(format: "%.2f", Double(self)/1024) + "KB"
        } else if self < 1024 * 1024 * 1024 {
            return String(format: "%.2f", Double(self)/(1024*1024)) + "MB"
        } else {
            return String(format: "%.2f", Double(self)/(1024*1024*1024)) + "GB"
        }
    }
    
    //MARK:随机数字
    static public func random(min:UInt32,max:UInt32)->UInt32{
        return  arc4random_uniform(max-min)+min
    }
}

