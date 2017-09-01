//
//  Date+Extensions.swift
//  FFToolModule
//
//  Created by apple on 16/7/13.
//  Copyright © 2017年 郑强飞. All rights reserved.
//

import Foundation

private let dateFormatter = DateFormatter()
private let calendar = Calendar.current

extension Date {
    
    /// 计算与当前系统时间偏差 delta 秒数的日期字符串
   public static func cz_dateString(delta: TimeInterval) -> String {
        
        let date = Date(timeIntervalSinceNow: delta)
        
        // 指定日期格式
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dateFormatter.string(from: date)
    }
    
    /// 将新浪格式的字符串转换成日期
    ///
    /// - parameter string: Tue Sep 15 12:12:00 +0800 2015
    ///
    /// - returns: 日期
   public static func cz_sinaDate(string: String) -> Date? {
        
        // 1. 设置日期格式
        dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss zzz yyyy"
        
        // 2. 转换并且返回日期
        return dateFormatter.date(from: string)
    }
    
    /**
     刚刚(一分钟内)
     X分钟前(一小时内)
     X小时前(当天)
     昨天 HH:mm(昨天)
     MM-dd HH:mm(一年内)
     yyyy-MM-dd HH:mm(更早期)
     */
   public var cz_dateDescription: String {
        
        // 1. 判断日期是否是今天
        if calendar.isDateInToday(self) {
            
            let delta = -Int(self.timeIntervalSinceNow)
            
            if delta < 60 {
                return "刚刚"
            }
            
            if delta < 3600 {
                return "\(delta / 60) 分钟前"
            }
            
            return "\(delta / 3600) 小时前"
        }
        
        // 2. 其他天
        var fmt = " HH:mm"
        
        if calendar.isDateInYesterday(self) {
            fmt = "昨天" + fmt
        } else {
            fmt = "MM-dd" + fmt
            
            let year = calendar.component(.year, from: self)
            let thisYear = calendar.component(.year, from: Date())
            
            if year != thisYear {
                fmt = "yyyy-" + fmt
            }
        }
        
        // 设置日期格式字符串
        dateFormatter.dateFormat = fmt
        
        return dateFormatter.string(from: self)
    }
    
    // MARK: - 返回当前日期 年份
    public var year: String {
        get {
            return toString("yyyy")
        }
    }
    
    // MARK: - 返回当前日期 月份
    public var month: String {
        get {
            return toString("MM")
        }
    }
    
    // MARK: - 返回当前日期 天
    public var day: String {
        get {
            return toString("dd")
        }
    }
    
    // MARK: - 返回当前日期 小时
    public var hour: String {
        get {
            return toString("HH")
        }
    }
    
    // MARK: - 返回当前日期 分钟
    public var minute: String {
        get {
            return toString("mm")
        }
    }
    
    // MARK: - 返回当前日期 秒数
    public var second: String {
        get {
            return toString("ss")
        }
    }
    
    // MARK: - 格式化日期
    public func toString(_ format: String) -> String {
        let df = DateFormatter();
        df.dateFormat = format;
        return df.string(from: self);
    }
}
