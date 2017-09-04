//
//  String+Extensions.swift
//  FFToolModule
//
//  Created by apple on 16/7/10.
//  Copyright © 2017年 郑强飞. All rights reserved.
//

import Foundation
import UIKit

extension String {
    // MARK: - 类型转换
    public func toBool() -> Bool {
        switch self {
        case "True", "true", "yes", "1":
            return true
        default:
            return false
        }
    }
    
    // MARK: - 手机号码验证
    public func isPhoneNumber() -> Bool {
        if self.characters.count != 11 {
            return false
        }
        let mobile = "^(13[0-9]|15[0-9]|18[0-9]|17[0-9]|147)\\d{8}$"
        let regexMobile = NSPredicate(format: "SELF MATCHES %@",mobile)
        if regexMobile.evaluate(with: self) == true {
            return true
        } else {
            return false
        }
    }
    
    // MARK: - 邮编号码的验证
    public func isZipCodeNumber() -> Bool {
        if self.characters.count == 0 {
            return false
        }
        let zipCodeNumber = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let regexCodeNumber = NSPredicate(format: "SELF MATCHES %@",zipCodeNumber)
        if regexCodeNumber.evaluate(with: self) == true {
            return true
        } else {
            return false
        }
    }
    // MARK: -邮箱验证
    public func isValidateEmail() ->Bool {
        let match = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let predicate = NSPredicate(format: "SELF MATCHES %@",match)
        if predicate.evaluate(with: self) == true {
            return true
        } else {
            return false
        }
    }
    
    // MARK: - URL验证
    public func isValidateHttpUrl() ->Bool {
        let match = "^(((file|gopher|news|nntp|telnet|http|ftp|https|ftps|sftp)://)|(www/.))+(([a-zA-Z0-9/._-]+/.[a-zA-Z]{2,6})|([0-9]{1,3}/.[0-9]{1,3}/.[0-9]{1,3}/.[0-9]{1,3}))(/[a-zA-Z0-9/&%_/./-~-]*)?$"
        let predicate = NSPredicate(format: "SELF MATCHES %@",match)
        if predicate.evaluate(with: self) == true {
            return true
        } else {
            return false
        }
    }
    
    // MARK: - 密码验证
    public func isValidatePassword() ->Bool {
        let match = "^[a-zA-Z0-9]\\S|\\S{5,15}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@",match)
        if predicate.evaluate(with: self) == true {
            return true
        } else {
            return false
        }
    }
    
    // MARK: - 判断空
    public func isNULLOrEmpty() ->Bool {
        if self.isEmpty || self == "" || self == "<null>" || self == "(null)" {
            return true
        }
        return false
    }
    
    // MARK: - 计算文本的汉字数
    public func calculateChineseCountInString(string:String) ->Int64 {
        if (string.isNULLOrEmpty()) {
            return 0
        }
        let len = string.characters.count
        let pattern = "[^\\x00-\\xff]"
        guard let regx = try? NSRegularExpression(pattern: pattern, options: [])
            else {
                return 0
        }
        let numMatch = regx.numberOfMatches(in: string, options: .reportProgress, range: NSRange(location: 0, length: len))
        return Int64((len + numMatch + 1) / 2)
    }
    
    // MARK: - URL字符串的编码与解码
    public func urlEncoded() -> String {
        let encodeUrlString = self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        return encodeUrlString ?? ""
    }
    
    // MARK: - 将编码后的url转换回原始的url
    public func urlDecoded() -> String {
        return self.removingPercentEncoding ?? ""
    }
    
    // MARK: - 根据开始位置和长度截取字符串
    public func subString(start:Int, length:Int = -1)->String {
        var len = length
        if len == -1 {
            len = characters.count - start
        }
        let st = characters.index(startIndex, offsetBy:start)
        let en = characters.index(st, offsetBy:len)
        let range = st ..< en
        return substring(with:range)
    }
    
    // MARK: - 根据开始位置和长度替换
    public func replacingCharacters(start:Int, length:Int = -1, with: String)->String {
        var len = length
        if len == -1 {
            len = characters.count - start
        }
        let st = characters.index(startIndex, offsetBy:start)
        let en = characters.index(st, offsetBy:len)
        let range = st ..< en
        return replacingCharacters(in: range, with: with)
    }
    
    // MARK: - 随机字符串
    static public func randomString(len:Int)->String{
        let min:UInt32=33,max:UInt32=127
        var string=""
        for _ in 0..<len{
            string.append(Character(UnicodeScalar(Int.random(min: min, max: max))!))
        }
        return string
    }
    
    /// 从当前字符串中，提取链接和文本
    /// Swift 提供了`元组`，同时返回多个值
    /// 如果是 OC，可以返回字典／自定义对象／指针的指针
    public  func cz_href() -> (link: String, text: String)? {
        
        // 0. 匹配方案
        let pattern = "<a href=\"(.*?)\".*?>(.*?)</a>"
        
        // 1. 创建正则表达式，并且匹配第一项
        guard let regx = try? NSRegularExpression(pattern: pattern, options: []),
            let result = regx.firstMatch(in: self, options: [], range: NSRange(location: 0, length: characters.count))
            else {
                return nil
        }
        
        // 2. 获取结果
        let link = (self as NSString).substring(with: result.rangeAt(1))
        let text = (self as NSString).substring(with: result.rangeAt(2))
        
        return (link, text)
    }
    
    public  func caleStringNeedSize(labelStr:String,font:UIFont) -> CGSize {
        let statusLabelText: NSString = labelStr as NSString
        let size = CGSize(width: UIScreen.main.bounds.width - 2 * 18, height: CGFloat(MAXFLOAT))
        let dic = NSDictionary(object: font, forKey: NSFontAttributeName as NSCopying)
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [String : AnyObject], context:nil).size
        return strSize
    }
    
    
    //计数文本所需的高度
    public func calStringheight(textString:String,widthLimit:CGFloat = UIScreen.cz_screenWidth(),font:UIFont = UIFont.systemFont(ofSize: 15)) -> CGFloat {
        let str = textString as NSString
        let rect = str.boundingRect(with: CGSize(width:widthLimit, height:CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:font], context: nil)
        return rect.height
    }
}
