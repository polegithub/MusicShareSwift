//
//  MsUserManager.swift
//  MusicShare
//
//  Created by poleness on 15/12/11.
//  Copyright © 2015年 poleness. All rights reserved.
//

import Foundation

let keyUserVerify = "verifyState"
let keyUserPhone = "userPhone"
let keyUserCityCode = "cityCode"
let keyUserCityName = "cityName"
let keyUserNickName = "nickName"

let keyMsUserInfoModel = "keyMsUserInfoModel"
let keyMsUserId = "keyMsUserId"
let keyMsUserToken = "keyMsUserToken"
//let keyMsUsertempProperty = "keyMsUsertempProperty"


let keyHasShowUserChoose = "keyHasShowUserChoose"

var userMgr:MsUserManager = MsUserManager.sharedInstance

class MsUserManager: NSObject {
    
    var msUserId :NSString = "0" //不要和userinfo中的userid冲突了
//    var tempProperty :MsuserType? = MsuserType.Unknown //用户首次进入自己选择的属性
//    var verifyState :MsUserVerifyState? = MsUserVerifyState.NotSubmit
//
//    var userPhone :NSString? = ""
//    var userCityCode:NSString? = ""
//    var userCityName:NSString? = ""
//    var nickName:NSString? = ""
    var msUserToken :NSString? = ""
    var hasShowLogin:Bool?
    
    var userInfo:MsUserModel = MsUserModel()
    
    static let sharedInstance = MsUserManager()
    
    //This prevents others from using the default '()' initializer for this class.
    private override init() {
        super.init()
        self.initData()
    }
    
     func initData() {
        let userDefault = NSUserDefaults.standardUserDefaults()
        let userId = userDefault .objectForKey(keyMsUserId) as? NSString
        
        self.msUserId = userId != nil ? userId!:self.msUserId
        self.msUserToken = userDefault.objectForKey(keyMsUserToken) as? NSString
        
        let data = userDefault.objectForKey(keyMsUserInfoModel) as? NSData
        if data != nil{
        self.userInfo =  NSKeyedUnarchiver .unarchiveObjectWithData(data!)! as! MsUserModel
        }else{
            self.userInfo = MsUserModel()
        }
//        self.tempProperty = MsuserType(rawValue: userDefault.integerForKey(keyMsUsertempProperty))!
//        self.verifyState = MsUserVerifyState(rawValue: userDefault.integerForKey(keyUserVerify))!
//        self.userPhone = userDefault.objectForKey(keyUserPhone) as? NSString
//        self.userCityCode = userDefault.objectForKey(keyUserCityCode) as? NSString
//        self.userCityName = userDefault.objectForKey(keyUserCityName) as? NSString
//        self.nickName = userDefault.objectForKey(keyUserNickName) as? NSString
        
        self.hasShowLogin = userDefault.objectForKey(keyHasShowUserChoose)?.boolValue
    }
    
    
    func isLogin()->Bool{
        let userDefault = NSUserDefaults.standardUserDefaults()
        let userId = userDefault .objectForKey(keyMsUserId) as? NSString
        if userId?.intValue > 0 {
            return true
        }
        return false
    }
    
    func setFirstLogin(){
        self.hasShowLogin = true
        NSUserDefaults.standardUserDefaults() .setValue(String("1"), forKey: keyHasShowUserChoose)
    }
    
    func setUserProperty(property:MsuserType){
        self.userInfo.userProperty = property
        self.updateUserInfo(self.userInfo)
    }
    
    
    //退出
    func userLogout(){
        //即时退出，用户的属性不变
        let userModel = MsUserModel()
        userModel.userId = "0"
        userModel.userProperty = self.userInfo.userProperty
        self.updateUserTokenInfo("0",userToken: "")
        
    }
    
    
    //更新数据
    func updateUserTokenInfo(userId:String, userToken:String){
        self.msUserId = userId
        self.msUserToken = userToken
        
        let userDefault = NSUserDefaults.standardUserDefaults()
        userDefault .setValue(userId, forKey: keyMsUserId)
        userDefault .setValue(userToken, forKey: keyMsUserToken)
    }
    
    func updateUserInfo(userModel:MsUserModel){
        self.userInfo = userModel
        
        let data = NSKeyedArchiver .archivedDataWithRootObject(userModel)
        let userDefault = NSUserDefaults.standardUserDefaults()
        userDefault .setValue(data, forKey: keyMsUserInfoModel)

    }
    
    func updateUserCityInfo(cityCode:NSString,cityName:NSString){
//        self.userCityCode = cityCode
//        self.userCityName = cityName
//        
//        let userDefault = NSUserDefaults.standardUserDefaults()
//        userDefault .setValue(cityCode, forKey: keyUserCityCode)
//        userDefault .setValue(cityName, forKey: keyUserCityName)
    }
    
    
}