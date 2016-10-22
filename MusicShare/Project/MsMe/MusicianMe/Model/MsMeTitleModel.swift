//
//  MsMeTitleModel.swift
//  MusicShare
//
//  Created by poleness on 15/12/13.
//  Copyright © 2015年 poleness. All rights reserved.
//

import Foundation

let keyMeCellTitle = "cellTitle"
let keyMeCellSubTitle = "cellSubTitle"
let keyMeCellImage = "imageName"

class MsMeTitleModel: NSObject {
    
    class func titleWithIndexPath(indexPath:NSIndexPath) -> NSDictionary {
        let section = indexPath.section
        let row = indexPath.row
        var title:String! = ""
        var subTitle:String! = ""
        var imgName:String! = ""
        
        let type = userMgr.userInfo.userProperty
        
        switch(section){
        case LoginSection:
            
            title = "登录"
            imgName = "me_account"
            break
        case ShowSection:
            
            if row == 0 {
                title = "我的相册"
                imgName =  "me_coupon"
                
            }else if row == 1 {
                title = "我的关注"
                imgName =  "me_focus"
            }
            break
        case PrivateSection:
            
            if row == 0 {
                title = "我的乐单"
                imgName = "me_collect"
            }else if row == 1 {
                title = "我的乐Show"
                imgName = "me_address"
            }else{
                title = "我的乐店"
                imgName = "me_address"
            }
            
            break
        case CertiSection:
            if type == MsuserType.Musician{
                title = "身份审核"
            }else if type == MsuserType.Shopper{
                title = "资质审核"
            }else{
                title = "身份验证"
            }
            subTitle = self.verifyDescription()
            imgName = "me_address"
            break
            
        case SettingSection:
            if row == 0 {
                title = "设置"
                imgName = "me_setting"
                
            }else if row == 1 {
                title = "关于"
                imgName = "me_collect"
            }
            break
            
        default:
            title  = ""
            imgName = ""
            break
        }
        
        let dic = NSMutableDictionary()
        dic .setValue(title, forKey: keyMeCellTitle)
        dic .setValue(subTitle, forKey: keyMeCellSubTitle)
        dic .setValue(imgName, forKey: keyMeCellImage)
        
        return dic
        
    }
    
    class func verifyDescription()->String {
        let state = userMgr.userInfo.verifyState
        if state == nil {
            return ""
        }
        var description:String = ""
        switch(state!){
        case MsUserVerifyState.NotSubmit:
            description = "尚未提交"
            break
        case MsUserVerifyState.SubmitSucc:
            description = "提交成功"
            break
        case MsUserVerifyState.SubmitFail:
            description = "提交失败"
            break
        case MsUserVerifyState.Verifying:
            description = "审核中"
            break
        case MsUserVerifyState.Reject:
            description = "审核被拒"
            break
        case MsUserVerifyState.Pass:
            description = "审核通过"
            break
        case MsUserVerifyState.Black:
            description = "黑名单"
            break
            
        }
        return description
    }
    
}
