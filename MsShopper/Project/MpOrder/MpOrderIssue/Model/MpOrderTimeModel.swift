//
//  MpOrderTimeModel.swift
//  MusicShare
//
//  Created by poleness on 16/1/26.
//  Copyright © 2016年 poleness. All rights reserved.
//

import UIKit

class MpOrderTimeModel: NSObject {

    var timeStart:String = ""
    var timeEnd:String = ""
    var deadline:String = "" //报名天数
    var price:String = "" //价格
    var peopleCount = 0 //需求人数
    
    
    required override init() {
        // This initializer must be required, because another
        // initializer `init(_ model: MpOrderTimeModel)` is required
        // too and we would like to instantiate `MpOrderTimeModel`
        // with simple `MpOrderTimeModel()` as well.
    }
    
    required init(_ model: MpOrderTimeModel) {
        // This initializer must be required unless `MpOrderTimeModel`
        // class is `final`
        timeStart = model.timeStart
        timeEnd = model.timeEnd
        deadline = model.deadline
        price = model.price
        peopleCount = model.peopleCount
        
    }
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        // This is the reason why `init(_ model: GameModel)`
        // must be required, because `GameModel` is not `final`.
        return self.dynamicType.init(self)
    }
    
    
    override func isEqual(object: AnyObject?) -> Bool {
        let model = object as! MpOrderTimeModel
        
        if self.timeStart != model.timeStart {
            return false
        }
        
        if self.timeEnd != model.timeEnd {
            return false
        }
        
        if self.deadline != model.deadline{
            return false
        }
        if self.price != model.price{
            return false
        }
        
        if self.peopleCount != model.peopleCount {
            return false
        }
        return true
        
    }
    
    
    
}
