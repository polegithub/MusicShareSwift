//
//  MsNavModel.swift
//  MusicShare
//
//  Created by poleness on 16/1/23.
//  Copyright © 2016年 poleness. All rights reserved.
//

import UIKit

class MsNavModel: NSObject {
    var navUrl:String = ""
    var navName:String = ""
    var navType:String = ""
    
    
    init(dataDic:NSDictionary) {
        super.init()
        self.navUrl = dataDic .stringWithKey("logo")
        self.navName = dataDic.stringWithKey("name")
        self.navType = dataDic.stringWithKey("type")
    }
}
