//
//  MsLocationManager.swift
//  MusicShare
//
//  Created by poleness on 16/1/3.
//  Copyright © 2016年 poleness. All rights reserved.
//

import UIKit


var userLocateMgr:MsLocationManager = MsLocationManager.sharedInstance

class MsLocationManager: NSObject ,CLLocationManagerDelegate{

    var locationForHeader:CLLocation! //请求头带的地址
    var locationImmediately:CLLocation!//时时地址

    var isGPSOn:Bool = false //GPS是否开启
    
    
    //define
    let kDistanceFilterNumber = 30.0
    
    
    //manager
    var sysLocationMgr:CLLocationManager!
    
    
    static let sharedInstance = MsLocationManager()
    private override init() {
      //This prevents others from using the default '()' initializer for this class.
        super.init()
    }
    
    func initSysLocationMgr() {
        self.sysLocationMgr = CLLocationManager()
        self.sysLocationMgr.delegate = self
        self.sysLocationMgr.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.sysLocationMgr.distanceFilter = kDistanceFilterNumber
        if SysVersion.IS_IOS8 {
            self.sysLocationMgr .requestWhenInUseAuthorization()
        }
        
    }
    
    
    //开启/关闭 定位
    func startLocationAction(){
        if CLLocationManager .locationServicesEnabled() == true {
            
            
        }else{
            let alert = UIAlertController(title: "您当前定位服务不可用", message: "请开启定位:设置 > 隐私 > 定位服务 > 乐享", preferredStyle: UIAlertControllerStyle.Alert)
            
            let cancelAction = UIAlertAction(title: "现在不", style: UIAlertActionStyle.Cancel, handler: nil)
            let setAction = UIAlertAction(title: "去设置", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                
            })
            
            alert .addAction(cancelAction)
            alert.addAction(setAction)
        }
    }
    
    func endLocationAction(){
        
    }
    
    
}
