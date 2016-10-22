//
//  MsAddressModel.swift
//  MusicShare
//
//  Created by poleness on 15/12/25.
//  Copyright © 2015年 poleness. All rights reserved.
//

import UIKit

class MsAddressModel: NSObject {
    
    
    var lat:String?
    var lng:String?
    var cityName:String? //地址对应的城市名称
    var cityCode:String? //地址对应的城市码
    
    var addressId:String! = "" //地址id
    
    var addressName:String!     //地址名称（店铺名称），如 上海xxx酒吧
    var addressContact:String! //地址联系人，如 张先生
    var addressDetail:String!   //详细地址，如 上海闵行区xxx路xx号
    var addressAdd:String!      //补充地址，如 二楼右拐第三个楼梯
    
    var addressFull:String!  //addressDetail + addressAdd
    
    var addressPhone:NSArray? //地址对应的手机-可能有多个手机，所以用数组
    
    override init() {
        super.init()
    }
    
    init(listDic:NSDictionary) {
        super.init()
        
        self.addressId = listDic.stringWithKey("id")
        
        self.lat = listDic.stringWithKey("latitude")
        self.lng = listDic.stringWithKey("longitude")
        
        self.cityCode = listDic.stringWithKey("city")
        
        self.addressName = listDic.stringWithKey("name")
        self.addressDetail = listDic.stringWithKey("address")

        self.addressContact = listDic.stringWithKey("contact")
        self.addressPhone = self.phoneArray(listDic)
        
    }
    
    //订单列表中的信息
    func getFromOrderList(addressDic:NSDictionary) {
        self.lat = addressDic.stringWithKey("latitude")
        self.lng = addressDic.stringWithKey("longitude")
        
        self.addressName = addressDic.stringWithKey("addressName")
        self.addressId = addressDic.stringWithKey("addressid")
        
        self.addressDetail = addressDic.stringWithKey("address")
        self.addressAdd = addressDic.stringWithKey("detail_address")
        
        self.addressFull = self.addressDetail + self.addressAdd
    }
    
    func phoneArray(dataDic:NSDictionary)->NSArray{
        let array = dataDic.objectForKey("telephoneNumbers") as! NSArray
        let array_M = NSMutableArray()
        for item in array{
            if item .isKindOfClass(NSString) == true {
                array_M .addObject(item)
            }else if item .isKindOfClass(NSNumber){
                array_M.addObject(String(item))
            }
        }
        return NSArray(array: array_M)
    }
    
    
}
