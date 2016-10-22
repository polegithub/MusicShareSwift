//
//  MsUserModel.swift
//  MusicShare
//
//  Created by poleness on 15/12/21.
//  Copyright © 2015年 poleness. All rights reserved.
//

import UIKit

class MsUserModel: NSObject {
    
    /*
    id数字。必选。唯一标识用户的数字。
    phoneNumber字符串。必选。手机号。
    userName字符串。可选。用户名。
    nickName字符串。可选。昵称。
    gender枚举的数字。必选。表示性别。可选的值有0（没有指定），1（男）和2（女）。
    userType枚举的数字。必选。表示用户类型。可选的值有0（乐迷），1（乐手）和2（商家）。
    state数字。必选。表示用户状态。可选的值有0（正常），1（待审核）。
    avatar字符串。可选。表示用户头像的 URL 地址。
    address字典。可选。用户所在地。
    following数字。必选。用户关注数。
    followers数字。必选。用户粉丝数。
    */
    
    var userId:String = "0"
    var userName:String?
    var nickName:String?
    
    //电话
    var phone:String?
    
    var userProperty:MsuserType?
    var verifyState:MsUserVerifyState?
    //性别
    var gender:MsGenderType = MsGenderType.Unknown
    
    //简介
    var intro:String = ""
    
    var address:MsAddressModel?
    
    var photoUrl :String = ""
    var following:Int?  //关注数
    var followers:Int?  //粉丝数
    var starScore:Int = 1 //1~5, 默认1分
    
    
    override init() {
        super.init()
    }
    
    init(userInfo:NSDictionary) {
        self.userId = userInfo.stringWithKey("id")
        self.phone = userInfo.stringWithKey("phoneNumber")
        self.userName = userInfo.stringWithKey("userName")
        self.nickName = userInfo.stringWithKey("nickName")
        self.intro = userInfo.stringWithKey("intro")
        self.gender = MsGenderType(rawValue: Int(userInfo.stringWithKey("gender"))!
            )!
        self.userProperty = MsuserType(rawValue: Int(userInfo.stringWithKey("userType"))!)!
        self.verifyState = MsUserVerifyState(rawValue: Int(userInfo.stringWithKey("state"))!)!
        //地址解析暂缓：需要addressmodel 序列化 2015-12-26followers
        //        self.address = MsAddressModel(addressDic: userInfo)
    }
    
    
    
    required init(coder: NSCoder) {
        super.init()
        
        self.userId = (coder .decodeObjectForKey("userId") as? String)!
        self.userName = coder.decodeObjectForKey("userName") as? String
        self.nickName = coder.decodeObjectForKey("nickName") as? String
        self.phone = coder.decodeObjectForKey("phone") as? String
        let userPropertyInt = coder.decodeObjectForKey("userProperty") as? Int
        if userPropertyInt != nil{
        self.userProperty = MsuserType(rawValue: userPropertyInt!)
        }
        let verifyStateInt = coder.decodeObjectForKey("verifyState") as? Int
        if verifyStateInt != nil{
        self.verifyState = MsUserVerifyState(rawValue: verifyStateInt!)
        }
        
        let genderInt =  coder.decodeObjectForKey("gender") as? Int
        if genderInt != nil{
        self.gender = MsGenderType(rawValue:genderInt!)!
        }
        self.intro = coder.decodeObjectForKey("intro") as! String
        self.following = coder.decodeObjectForKey("following") as? Int
        self.followers = coder.decodeObjectForKey("followers") as? Int
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.userId, forKey: "userId")
        coder.encodeObject(self.userName, forKey: "userName")
        coder.encodeObject(self.nickName, forKey: "nickName")
        coder.encodeObject(self.phone, forKey:"phone")
        coder.encodeObject(self.userProperty?.rawValue,forKey:"userProperty")
        coder.encodeObject(self.verifyState?.rawValue, forKey: "verifyState")
        coder.encodeObject(self.gender.rawValue, forKey: "gengder")
        coder.encodeObject(self.intro, forKey: "intro")
        coder.encodeObject(self.followers, forKey: "followers")
        coder.encodeObject(self.following, forKey: "following")
    }
    
}
