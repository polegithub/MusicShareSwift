//
//  MsRequestModel.swift
//  MusicShare
//
//  Created by poleness on 15/12/12.
//  Copyright © 2015年 poleness. All rights reserved.
//

import Foundation

/// 请求做一次封装
class MsRequestModel: NSObject {
    
    var urlBody:String = ""
    var requestParameters = NSMutableDictionary()
    
    
    func initWithBody(body:String)->MsRequestModel{
        self.urlBody = body
        
        return self
    }
    
    
    func setStringParameters(value:String,key:String){
        if value.isEmpty || key.isEmpty{
            return
        }
        self.requestParameters .setValue(value, forKey: key)
    }
    
    func setNumberParameters(value:NSNumber,key:String){
        if key.isEmpty{
            return
        }
        
        self.requestParameters.setValue(value, forKey: key)
        
    }
    
    func setArrayParameters(value:NSArray,key:String){
        self.requestParameters .setValue(value, forKey: key)
    }
    
    
    
    /**
     *  乐手 API
     */
     
     
     /**
     登录注册 - 获取验证码
     
     - parameter phone: phone description
     
     - returns: return value description
     */
    class func requestForGetLoginCaptcha(phone:String)->MsRequestModel {
        let body:String = "account/captcha"
        let request = MsRequestModel()
        request.urlBody = body
        request.setStringParameters(phone, key: "phoneNumber")
        return request
    }
    
    //    class func requestForUserInfo()->MsRequestModel {
    //        let body:String = "/account/captcha"
    //        let request = MsRequestModel.init()
    //        request.urlBody = body
    //        request.setStringParameters(userMgr.userId as! String, key: "userId")
    //        return request
    //    }
    
    class func requestForLogin(phone:String,captcha:String,userType:String)->MsRequestModel {
        let body:String = "account/signIn"
        let request = MsRequestModel()
        request.urlBody = body
        request.setStringParameters(phone, key: "phoneNumber")
        request.setStringParameters(captcha, key: "captcha")
        request.setStringParameters(userType, key: "accountType")
        return request
    }
    
    
    /**
     请求banner
     
     - returns: return value description
     */
    class func requestForBanner()->MsRequestModel {
        let body:String = "home/banner"
        let request = MsRequestModel()
        request.urlBody = body
        return request
    }
    
    /**
     请求导航
     
     - returns: return value description
     */
    class func requestForNavType()->MsRequestModel {
        let body:String = "home/type"
        let request = MsRequestModel()
        request.urlBody = body
        return request
    }
    
    /**
     获取用户的基本信息
     
     - returns: return value description
     */
    class func requestForUserBriefInfo()->MsRequestModel {
        let body:String = "account/brief"
        let request = MsRequestModel()
        request.urlBody = body
        return request
    }
    
    
    /**
     *  演出
     */
     
     //获取全部的订单列表-普通订单
    class func requestForAllNormalOrderList(page:String) {
        let body:String = "/mOrder/music/list"
        let request = MsRequestModel()
        request.urlBody = body
        request.setStringParameters(page, key: "pageIndex")
    }
    
    //音乐人报名抢单
    class func requestForGrabOrder(userId:String,orderId:String,timeId:String)->MsRequestModel{
        let body:String = "mOrder/music/grab"
        let request = MsRequestModel()
        request.urlBody = body
        
        request.setStringParameters(userId, key: "accountid")
        request.setStringParameters(orderId, key: "orderid")
        request.setStringParameters(timeId, key: "timeid")
        return request
    }
    
    
    //获取演出列表
    class func requestForUserShowList(page:String) ->MsRequestModel {
        let body:String = "my/performance"
        let request = MsRequestModel()
        request.urlBody = body
        request .setStringParameters(page, key: "pageIndex")
        return request
    }
    
    
    /**
     * 订单
     */
    //我的订单列表 - 普通订单
    class func requestForMsMyNormalOrderList(userId:String, page:String,state:String)->MsRequestModel{
        let body:String = "mOrder/music/list"
        let request = MsRequestModel()
        request.urlBody = body
        request .setStringParameters(page, key: "pageIndex")
        request.setStringParameters(userId, key: "accountid")
        request.setStringParameters(state, key: "state")
        
        return request
    }
    
    //待结单列表 - 音乐人抢单列表
    class func requestForMsAvailableNormalOrderList(page:String,userId:String)->MsRequestModel{
        let body:String = "mOrder/music/aviabled"
        let request = MsRequestModel()
        request.urlBody = body
        request .setStringParameters(page, key: "pageIndex")
        request.setStringParameters(userId, key: "accountid")

        return request
    }

    
    
    class func requestForMyOrderList()->MsRequestModel {
        let body:String = "v1_0/my/order/list"
        let request = MsRequestModel()
        request.urlBody = body
        
        return   request
        
    }
    
    
    /**
     *  地址
     */
     //查
    class func requestForAddressList() ->MsRequestModel {
        let body:String = "my/address/list"
        let request = MsRequestModel.init()
        request.urlBody = body
        return request
    }
    
    //增
    class func requestForAddressNew(latitude:String,longitude:String,name:String,address:String,detailAddress:String,cityCode:String,contact:String,phoneArray:NSArray) ->MsRequestModel {
        let body:String = "my/address/new"
        let request = MsRequestModel.init()
        request.urlBody = body
        
        request.setStringParameters(latitude, key: "latitude")
        request.setStringParameters(longitude, key: "longitude")
        request.setStringParameters(address, key: "address")
        request.setStringParameters(detailAddress, key: "detailAddress")
        request.setStringParameters(name, key: "name")
        request.setStringParameters(cityCode, key: "city")
        request.setStringParameters(contact, key: "contact")
        request.setArrayParameters(phoneArray, key: "telephoneNumbers")
        
        return request
    }
    
    //删
    class func requestForAddressDelete(addressId:String)->MsRequestModel{
        let body:String = "my/address/destroy"
        let request = MsRequestModel.init()
        request.urlBody = body
        
        request .setStringParameters(addressId, key: "id")
        return request
    }
    
    //改
    class func requestForAddressUpdate(addressId:String)->MsRequestModel{
        let body:String = "my/address-book/update"
        let request = MsRequestModel.init()
        request.urlBody = body
        
        request .setStringParameters(addressId, key: "id")
        return request
    }
    
    
    
    /**
     *  商家 API
     */
     
     //发布订单准备
    class func requestForShopOrderStyleList()->MsRequestModel{
        let body:String = "mOrder/style/list"
        let request = MsRequestModel()
        request.urlBody = body
        return request
    }
    
    //发布订单--普通订单
    class func requestForShopCreateOrder(userId:String,title:String,style:NSArray,timeArray:NSArray,addressId:String,description:String)->MsRequestModel{
        let body:String = "mOrder/merchant/create"
        let request = MsRequestModel()
        request.urlBody = body
        request.setStringParameters(userId, key: "accountid")
        request.setStringParameters(title, key: "title")
        request.setStringParameters(description, key: "description")
        request.setStringParameters(addressId, key: "addressid")
        request.setArrayParameters(timeArray, key: "times")
        request.setArrayParameters(style, key: "styles")
        
        return request
    }
    
    //获取各个状态的订单列--普通订单
    class func requestForShopNormalOrderList(userId:String,page:String,state:String)->MsRequestModel {
        let body:String = "mOrder/merchant/list"
        let request = MsRequestModel()
        request.urlBody = body
        request.setStringParameters(userId, key: "accountid")
        request.setStringParameters(page, key: "pageIndex")
        request.setStringParameters(state, key: "state")
        //        request.setStringParameters("10", key: "pageSize")
        return request
    }
    
    //订单详情
    class func requestForShopOrderDetail(orderId:String,timeId:String)->MsRequestModel{
        let body:String = "mOrder/merchant/detail"
        let request = MsRequestModel()
        request.urlBody = body
        request.setStringParameters(orderId, key: "orderid")
        request.setStringParameters(timeId, key: "timeid")
        return request
        
    }
    
    //订单已报名乐手列表
    class func requestForSignUpMusicianListOfOrder(userId:String,page:String,orderId:String,timeId:String)->MsRequestModel{
        let body:String = "mOrder/merchant/grabList"
        let request = MsRequestModel()
        request.urlBody = body
        
        request.setStringParameters(userId, key: "accountid")
        request.setStringParameters(page, key: "pageIndex")
        request.setStringParameters(orderId, key: "orderid")
        request.setStringParameters(timeId, key: "timeid")
        return request
    }
    
    //订单选择乐手
    class func requestForSelectorMusicianByShop(orderId:String,timeid:String,musicianId:String){
        
    }
}
