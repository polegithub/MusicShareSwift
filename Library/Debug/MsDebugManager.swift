//
//  MsDebugManager.swift
//  MusicShare
//
//  Created by poleness on 15/12/10.
//  Copyright © 2015年 poleness. All rights reserved.
//

import Foundation

var debugMgr:MsDebugManager = MsDebugManager.sharedInstance

class MsDebugManager: NSObject {

    static let sharedInstance = MsDebugManager()
    private override init() {} //This prevents others from using the default '()' initializer for this class.
    
    
    func isOnlineUrl()->Bool{
        return true
    }
}
