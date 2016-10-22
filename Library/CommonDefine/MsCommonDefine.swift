//
//  MsCommonDefine.swift
//  MusicShare
//
//  Created by poleness on 15/12/6.
//  Copyright © 2015年 poleness. All rights reserved.
//

import UIKit

let APPCFBundleIdentifier = NSBundle.mainBundle().infoDictionary!["CFBundleIdentifier"]

let isMsApp:Bool = APPCFBundleIdentifier!.isEqualToString("com.ms.musician")
let isMpApp:Bool = APPCFBundleIdentifier!.isEqualToString("com.ms.musicshop")


struct SysVersion {
    static let IS_IOS7 = (UIDevice.currentDevice().systemVersion as NSString).doubleValue >= 7.0
    static let IS_IOS8 = (UIDevice.currentDevice().systemVersion as NSString).doubleValue >= 8.0
    static let IS_IOS9 = (UIDevice.currentDevice().systemVersion as NSString).doubleValue >= 9.0
}


/**
 *============================= iPhone Screen Size ===========================
 */

/// 获取屏幕的宽
let kScreenWidth = UIScreen.mainScreen().bounds.size.width
/// 获取屏幕的高
let kScreenHeight = UIScreen.mainScreen().bounds.size.height
/// 屏幕的frame
let kScreenFrame = UIScreen.mainScreen().bounds


struct ScreenSize{
    static let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
    static let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height
    static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct Device{
    static let IS_IPHONE_4 =  UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 480.0
    static let IS_IPHONE_5 = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6 = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
}

/**
 *============================= Unit Size ===========================
 */

let cellLeftMargin:CGFloat = Device.IS_IPHONE_6P ? 20:15

class MsCommonDefine: NSObject {

    
}
