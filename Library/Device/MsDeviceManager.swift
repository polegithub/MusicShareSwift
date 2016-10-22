//
//  DeviceManager.swift
//  shop
//
//  Created by 孟 智 on 14-9-15.
//  Copyright (c) 2014年 DaDa Inc. All rights reserved.
//

import Foundation
import UIKit
import KeychainSwift

var deviceMgr:DeviceManager = DeviceManager.shareInstance()
class DeviceManager {
    
    var identifierForVendor:String = ""
    
    class func shareInstance() -> DeviceManager {
        struct DBSingleton{
            static var predicate:dispatch_once_t = 0
            static var instance:DeviceManager? = nil
        }
        
        dispatch_once(&DBSingleton.predicate, {
            DBSingleton.instance = DeviceManager()
        })
        return DBSingleton.instance!
    }
    
    func systemName() -> String {
        return UIDevice.currentDevice().systemName
    }
    
    func systemVersion() -> String {
        return UIDevice.currentDevice().systemVersion
    }
    
    func isGreaterThan8() -> Bool {
        if (self.systemVersion() as NSString).floatValue >= 8 {
            return true
        } else {
            return false
        }
    }
    
    func isGreaterThan9() -> Bool {
        if (self.systemVersion() as NSString).floatValue >= 9 {
            return true
        } else {
            return false
        }
    }
    
    func model() -> String {
        return UIDevice.currentDevice().model
    }
    
    func udid() -> String {
         let uuid = NSUUID().UUIDString
        return uuid

    }
    
    
}