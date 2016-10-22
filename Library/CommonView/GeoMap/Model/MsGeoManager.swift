//
//  MsGeoManager.swift
//  MusicShare
//
//  Created by poleness on 15/12/30.
//  Copyright © 2015年 poleness. All rights reserved.
//

import UIKit

var geoMapView:MAMapView = MsGeoManager.shareMapView()

class MsGeoManager: NSObject {


static var mapView:MAMapView? = nil

class func shareMapView()->MAMapView {
    MAMapServices .sharedServices().apiKey = kAMapSearchApplicationSecretKey

    if mapView == nil {
        mapView = MAMapView(frame: UIScreen.mainScreen().bounds)
        mapView?.autoresizingMask = [.FlexibleHeight,.FlexibleWidth]
        mapView?.zoomEnabled = true
        mapView?.showsUserLocation = true
    }
    return mapView!
}

    
//    //重写allocWithZone保证分配内存alloc相同
//    + (id)allocWithZone:(NSZone *)zone {
//        @synchronized(self) {
//            
//            if (_mapView == nil) {
//                _mapView = [super allocWithZone:zone];
//                return _mapView; // assignment and return on first allocation
//            }
//        }
//        return nil; // on subsequent allocation attempts return nil
//        }
//        
//        //保证copy相同
//        + (id)copyWithZone:(NSZone *)zone {
//            return _mapView;
//}

        
    
    

}
