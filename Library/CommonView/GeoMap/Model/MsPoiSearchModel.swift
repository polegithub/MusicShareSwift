//
//  MsPoiSearchModel.swift
//  MusicShare
//
//  Created by poleness on 15/12/30.
//  Copyright © 2015年 poleness. All rights reserved.
//

import UIKit

class MsPoiSearchModel: NSObject {
    
    typealias POISearchResult = ()->(result:NSArray, error:NSError, request:AnyObject)
    typealias GeoResult = ()->(AMapGeoPoint) //地理编码
    typealias ReGeoResult = ()->(AMapReGeocode) //逆向地理编码
    
    
    //输入有效性检查
    func isInputKeyValid(string:NSString)->Bool{
        if string.length == 0 {
            return false
        }
        
        //需要检查emoji 表情
//        if string.is
        
        return true
    }
    

    
    /**
    *  查找周边
    *
    *  @param keyString keyString description
    *  @param result    result description
    */
//    func startRoundPOISearchWithKey(keyString:NSString)->POISearchResult{
//        
//    }
    
    /**
    *  指定类型查找
    *
    *  @param keyString  keyString description
    *  @param result     result description
    *  @param searchType searchType description
    */
//    func startAppointPOISearch(keyString:NSString, searchType:AMapSearchType)->POISearchResult{

//        if self.isInputKeyValid(keyString) != true {
//          return
//        }
//        
//        AMapPlaceSearchRequest *request =
//            [self createSearchRequestWithKey:keyString
//                andAMapSearchType:AMapSearchType_PlaceAround
//                andSortrule:1];
//        [self.searchAPI AMapPlaceSearch:request];
//        self.searchResult = result;
//    }

    
    /**
    *  地理编码查询
    *
    *  @param keyString keyString description
    *  @param cityCode cityCode description:
    *         城市Array，(可选值)：
    *         [cityname（中文或中文全拼）,citycode, adcode NSString数组]
    *         目前仅用cityCode
    *  @param result    result description (经纬度坐标)
    */
//    func startAddressGeocodeSearch(keyString:NSString, cityCode:NSArray)->GeoResult{
//        
//    }

    /**
    *  逆地理编码查询
    *
    *  @param coordinate coordinate description
    */
//    func startAMapReGeocodeSearch(coordinate:CLLocationCoordinate2D)->ReGeoResult{
//        
//    }

}
