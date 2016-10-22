//
//  MsShowModel.swift
//  MusicShare
//
//  Created by poleness on 15/12/27.
//  Copyright © 2015年 poleness. All rights reserved.
//

import UIKit

class MsOrderModel: NSObject {
    /*
    "id": 1,
    "name": "Freaky is good! 2015 厦门草莓音乐节",
    "style": "摇滚, 民谣",
    "date": {
    "from": "2015-11-07 00:00:00",
    "to": "2015-11-08 00:00:00"
    }
    "address": "福建省 厦门市 集美区 杏林湾大草地（集美区银江路水上运动中心附近）"
    */
    
//    var showId:String = "0"
    var title:String = ""
    var orderDesc:String = ""
    
    var timeStart:String?
    var timeEnd:String?
    var timePeriod:String = ""
    
    var singerInfo:String = ""

    var shopName:String = "" //演出需要这个shop name
    var shopLogo:String = "" //商铺logo
    
    var address:MsAddressModel?
    
    var process : CGFloat = 0 //进度条 0.0 ~ 1.0
    
    var imageUrl:String?
    
    //订单的基本信息
    var orderId:String = "0"
    
    override init() {
        
    }
    
    init(showListData:NSDictionary) {
        self.orderId = showListData.stringWithKey("id")
        self.title = showListData.stringWithKey("name")
        
        let dateDic = showListData .objectForKey("date") as? NSDictionary
        self.timeStart = dateDic?.stringWithKey("from")
        self.timeEnd = dateDic?.stringWithKey("to")
        
        let addDic = showListData .objectForKey("address") as? NSDictionary
        if addDic != nil{
            self.address = MsAddressModel(listDic: addDic!)
        }}
    
    func desription()->NSString{
        let str:NSString = NSString(format: "id:%@\nname:%@ time:%@ ",self.orderId,self.title,self.timePeriod)
        return str
    }
}
