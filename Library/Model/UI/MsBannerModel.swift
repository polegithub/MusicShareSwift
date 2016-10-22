//
//  MsBannerModel.swift
//  MusicShare
//
//  Created by poleness on 16/1/22.
//  Copyright © 2016年 poleness. All rights reserved.
//

import UIKit

class MsBannerModel: NSObject {
  
    var bannerId:String = ""
    var bannerUrl:String = "" //图像url
    var bannerLink:String = ""//点击后链接
    
    
    init(dataDic:NSDictionary) {
        super.init()
        self.bannerId = dataDic .stringWithKey("id")
        self.bannerUrl = dataDic.stringWithKey("file")
        self.bannerLink = dataDic.stringWithKey("link")
    }
    
    
    //从nsobject解析回来
    init(coder aDecoder:NSCoder!){
        self.bannerId = aDecoder.decodeObjectForKey("bannerId") as! String
        self.bannerUrl = aDecoder.decodeObjectForKey("bannerUrl") as! String
        self.bannerLink = aDecoder.decodeObjectForKey("bannerLink") as! String
    }
    
    //编码成object
    func encodeWithCoder(aCoder:NSCoder!){
        aCoder.encodeObject(bannerId,forKey:"bannerId")
        aCoder.encodeObject(bannerUrl,forKey:"bannerUrl")
        aCoder.encodeObject(bannerLink,forKey: "bannerLink")
    }
}
