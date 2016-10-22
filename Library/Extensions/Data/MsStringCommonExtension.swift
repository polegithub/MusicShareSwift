//
//  StringCommonExtension.swift
//  JokerMost
//
//  Created by ljy-335 on 14-10-9.
//  Copyright (c) 2014年 uni2uni. All rights reserved.
//

import Foundation
import UIKit

///
/// @brief String的通用扩展方法
/// @date  2014-10-09
/// @author huangyibiao
///
extension String {
    
    var md5: String! {
        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let strLen = CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
        
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        
        result.destroy()
        
        return String(format: hash as String)
    }
    
    //正则匹配 电话号码
    func isValidChinesePhone(phone:String)->Bool{
        let  phoneRegex = "1[0-9]{10}";
        let phoneCheck = NSPredicate(format: "SELF MATCHES%@", phoneRegex)
        let isValid:Bool = phoneCheck.evaluateWithObject(phone)
        return isValid
    }
    
    func isValidNumber()->Bool{
        let  regex = "^[0-9]*$";
        let check = NSPredicate(format: "SELF MATCHES%@", regex)
        let isValid:Bool = check.evaluateWithObject(self)
        return isValid

    }
    
    //时间
    func timeStrWithFormat(dateFormat:String = "yy-MM-dd hh:mm")->String{
        if self.isEmpty{
            return ""
        }
        let dateValue = NSDate(timeIntervalSince1970: NSTimeInterval(self)!)
        let format = NSDateFormatter()
        format.dateFormat = dateFormat
        let dateStr = format.stringFromDate(dateValue)
        return dateStr
    }

    ///
    /// @brief 获取字符串的高度
    /// @param fontSize 字体大小
    /// @param width 限制一行显示的宽度
    /// @return 返回文本在width宽度的条件下的总高度
    ///
    func textSize(let fontSize: CGFloat, let maxWidth: CGFloat = CGSizeZero.width,let maxHeight:CGFloat = CGSizeZero.height) ->CGSize {
        if self.isEmpty {
            return CGSizeZero
        }
        
        let font = UIFont.systemFontOfSize(fontSize)
        let size = CGSizeMake(maxWidth, CGFloat.max)
        
        let style = NSMutableParagraphStyle()
        style.lineBreakMode = NSLineBreakMode.ByCharWrapping
        
        let attributes = [NSFontAttributeName: font, NSParagraphStyleAttributeName: style.copy()];
        
        // 强转成NSString
        let text = self as NSString
        let rect = text.boundingRectWithSize(size,
            options: NSStringDrawingOptions.UsesLineFragmentOrigin,
            attributes: attributes,
            context: nil)
        
        return rect.size
    }
    
    
    func stringLength() ->Int{
        if self.isEmpty{
            return 0
        }
        let p = self.cStringUsingEncoding(NSUnicodeStringEncoding)
        return (p?.count)!;
    }
    
    
}


extension Int {
    func toDateString(formatString:String) -> String {
        let selfValue: NSTimeInterval = (self as AnyObject) as! NSTimeInterval
        let date:NSDate = NSDate(timeIntervalSince1970: selfValue)
        let format:NSDateFormatter = NSDateFormatter()
        format.dateFormat = formatString
        return format.stringFromDate(date)
    }
}