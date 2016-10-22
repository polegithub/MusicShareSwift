//
//  MsDictionaryExtension.swift
//  MusicShare
//
//  Created by poleness on 15/12/10.
//  Copyright © 2015年 poleness. All rights reserved.
//

import Foundation
import UIKit

extension NSDictionary {
    
    //url encode -仅限全是string
    func urlEncodedStringForGet () -> String {
        
        let keyArray = NSMutableArray()
        let sortedArray = NSMutableArray()
        
        for key in self.allKeys {
            keyArray .addObject(key)
        }
        keyArray .sortUsingSelector(Selector("compare:"))
        
        for key in keyArray {
            var value: AnyObject = self.objectForKey(key as! String)! as! String
            var keyString:String = key as! String
            value = value.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
            keyString = keyString.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
            
            let part = String(format: "%@=%@", keyString, "\(value)")
            sortedArray .addObject(part as AnyObject)
        }
        
        let encodeQuery = NSMutableString()
        
        var index = 1
        for str in sortedArray {
            
            if index == 1 {
                encodeQuery.appendString((str as? String)!)
            }else {
                encodeQuery.appendFormat("&%@", encodeQuery)
            }
            index++
        }
        
        return encodeQuery as String
    }
    
    // post - json
//    - (NSString *)urlEncodedStringForPostWithJSON {
//    
//    NSString *jsonString = nil;
//    if ([NSJSONSerialization isValidJSONObject:self]) {
//    NSData *jsonData =
//    [NSJSONSerialization dataWithJSONObject:self options:0x0 error:nil];
//    jsonString =
//    [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    } else {
//    DDLogDebug(@"post格式不正确！！");
//    }
//    DDLogDebug(@"%@", jsonString);
//    return jsonString;
//    }
    
    func urlEncodedStringForPost()->String{
        var jsonString:NSString = ""
        if NSJSONSerialization .isValidJSONObject(self){

            do {
                let jsonData = try NSJSONSerialization .dataWithJSONObject(self, options: NSJSONWritingOptions.PrettyPrinted) as NSData
                    jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding)!
                
            } catch {
                NSLog("日了狗了")
            }

        }else{
            //json格式错误
        }
        
        return jsonString as String
    }
    
    
    //解析
    //string解析
    func stringWithKey(key:String)->String{
        
        if  self .isKindOfClass(NSDictionary) == false {
            return ""
        }
        
        let object = self.objectForKey(key)
        if object == nil{
            return ""
        }
            
        var stringObj:String = ""
        if object!.isKindOfClass(NSString) == true{
             stringObj = object as! String
        }else if object!.isKindOfClass(NSNumber) == true {
             stringObj = object!.stringValue
        }
        if stringObj.isEmpty {
            return ""
        }else{
            return stringObj
        }
        
    }
    
}

