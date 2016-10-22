//
//  MsCommonType.swift
//  MusicShare
//
//  Created by poleness on 15/12/12.
//  Copyright © 2015年 poleness. All rights reserved.
//

import Foundation

enum MsuserType:Int {
    case Consumer = 0  //普通用户
    case Musician = 1  //音乐人
    case Shopper = 2   //商家（琴行/酒吧）
    case Unknown = 4   //首次使用
}

enum MsUserVerifyState:Int {
    case NotSubmit = 0      //未提交
    case SubmitFail = 1     //提交失败
    case SubmitSucc = 2     //已提交成功
    case Verifying = 4      //审核中
    case Reject = 11        //审核被拒
    case Pass = 12          //审核通过
    case Black = 99         //拉入黑名单
}


enum MsGenderType:Int{
    //值有0（没有指定），1（男）和2（女）。
    case Unknown = 0
    case Man
    case Woman
}

struct OrderOrient{
    static let PubOrder =  0
    static let AcceptOrder = 1
}

struct OrderBelong{
    static let PubOrder =  0 //公海order
    static let PerOrder = 1  //私海order
}

//数据刷新类型
struct refreshType{
    static let refresh = 0
    static let loadMore = 1
}

//发布订单
struct OrderType{
    static let normal = 0
    static let resident = 1
    static let show = 2
}

