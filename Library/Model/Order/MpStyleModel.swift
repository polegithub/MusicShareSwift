//
//  MpStyleModel.swift
//  MusicShare
//
//  Created by poleness on 16/2/28.
//  Copyright © 2016年 poleness. All rights reserved.
//

import UIKit

class MpStyleModel: NSObject {
    
    var styleName:String = ""
    var styleId:String = ""

    override init() {
        
    }
    
    init(styleDic:NSDictionary) {
        self.styleId = styleDic.stringWithKey("id")
        self.styleName = styleDic.stringWithKey("tag")
    }
}
