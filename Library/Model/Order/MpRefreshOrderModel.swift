//
//  MpRefreshOrderModel.swift
//  MusicShare
//
//  Created by poleness on 16/2/25.
//  Copyright © 2016年 poleness. All rights reserved.
//

import UIKit

class MpRefreshOrderModel: NSObject {
    
    var currentPage:Int = 0
    var totalPage:Int =  0
    
    var orderType:Int = OrderType.normal
    
    var state:Int = 0 //module对应的state -固定
    
    //data
    var dataArray = NSArray()
    
    init(state:Int,orderType:Int) {
        self.state = state
        self.orderType = orderType
    }
    
    
    func refreshData(){
        
    }
}
