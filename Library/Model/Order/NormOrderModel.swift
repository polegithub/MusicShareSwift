//
//  MpOrderModel.swift
//  MusicShare
//
//  Created by poleness on 16/1/31.
//  Copyright © 2016年 poleness. All rights reserved.
//

import UIKit

class NormOrderModel: NSObject {
    
    
    var title:String = ""
    var orderDesc:String = ""
    
    var timeStart:String = ""
    var timeEnd:String = ""
    var timePeriod:String = ""
    var deadline:String = ""
    
    var orderType:Int = OrderType.normal
    
    var singerInfo:MsUserModel = MsUserModel()
    
    var peopleNeed:Int = 0 //需求人数人数
    var signUpCount:Int = 0 //报名人数
    //    var orderMusician: //已选乐手
    
    var shopName:String = "" //演出需要这个shop name
    var shopLogo:String = ""
    
    var state:Int = 0
    var stateDesc:String = ""
    
    //位置信息
    var address:MsAddressModel?
    
    var process : CGFloat = 0 //进度条 0.0 ~ 1.0
    
    var styleArray:NSArray = NSArray()  //风格的数组
    
    //价格
    var price:String = ""
    
    //订单的基本信息
    var orderId:String = "0"
    var timeId:String = "0"
    
    override init() {
        super.init()
    }
    
    init(orderData:NSDictionary) {
        super.init()
        
        //shop logo
        self.shopLogo = orderData.stringWithKey("photoUrl")
        
        self.orderId = orderData.stringWithKey("orderid")
        self.title = orderData.stringWithKey("title")
        self.orderDesc = orderData.stringWithKey("description")
        
        //时间
        self.timeStart = orderData.stringWithKey("starttime")
        self.timeEnd = orderData.stringWithKey("endtime")
        self.deadline = orderData.stringWithKey("deadline")
        self.timeId = orderData.stringWithKey("timeid")
        
        //状态
        self.stateDesc = orderData.stringWithKey("stateString")
        
        self.price = orderData.stringWithKey("price")
        
        let countStr:NSString = orderData.stringWithKey("needCount") as NSString
        self.peopleNeed = Int(countStr.intValue)
        
        self.getStyleData(orderData.objectForKey("style") as! NSArray)
        self.getAddressData(orderData)
    }
    
    func getStyleData(styleData:NSArray){
        if styleData.count >  0{
            let array_M = NSMutableArray()
            for item in styleData{
                let model = MpStyleModel()
                model.styleName = item as! String
                array_M .addObject(model)
            }
            self.styleArray = NSArray(array: array_M)
        }
    }
    
    func getAddressData(addressDic:NSDictionary){
        if addressDic.count > 0{
            self.address = MsAddressModel()
            self.address?.getFromOrderList(addressDic)
        }
    }
    
    func desription()->NSString{
        let str:NSString = NSString(format: "id:%@\nname:%@ time:%@ ",self.orderId,self.title,self.timePeriod)
        return str
    }
    
}
