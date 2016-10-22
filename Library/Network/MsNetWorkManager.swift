//
//  netWorkManager.swift
//
//
//  Created by 孟 智 on 14-8-29.
//  Copyright (c) 2014年 Dreambuffer. All rights reserved.
//

import Foundation
import CoreLocation
import AFNetworking
import SVProgressHUD

import Qiniu
import HappyDNS


/*
常用url set
URLFragmentAllowedCharacterSet  "#%<>[\]^`{|}
URLHostAllowedCharacterSet      "#%/<>?@\^`{|}
URLPasswordAllowedCharacterSet  "#%/:<>?@[\]^`{|}
URLPathAllowedCharacterSet      "#%;<>?[\]^`{|}
URLQueryAllowedCharacterSet     "#%<>[\]^`{|}
URLUserAllowedCharacterSet      "#%/:<>?@[\]^`
*/

var netWorkMgr:NetWorkManager = NetWorkManager.shareInstance()
var afNetWorkManager:AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()

let token_invalid = "-268444430"   //token过期

class NetWorkManager {
    
    class func shareInstance() -> NetWorkManager {
        struct DBSingleton{
            static var predicate:dispatch_once_t = 0
            static var instance:NetWorkManager? = nil
        }
        dispatch_once(&DBSingleton.predicate, {
            DBSingleton.instance = NetWorkManager()
        })
        return DBSingleton.instance!
    }
    
    //http header
    func httpHeader(params:NSDictionary,isPost:Bool)-> NSDictionary{
        let lat = "0"
        let lng = "0"
        //        if let location:String? = location {
        //            if location != nil {
        //                let locationArray = location!.componentsSeparatedByString(",")
        //                lat = locationArray[0] as String
        //                lng = locationArray[1] as String
        //            }
        //        }
        
        let appVersion = NSBundle.mainBundle().infoDictionary!["CFBundleVersion"] as! String
        //        var cityCode: AnyObject! = userMgr.userCityCode
        //        if cityCode == nil {
        //            cityCode = 0
        //        }
        let nsuserid = userMgr.msUserId
        
        var queryString = ""
        
        if  params.count > 0 {
            if isPost == true{
                queryString = params.urlEncodedStringForPost()
            }else{
                queryString = params.urlEncodedStringForGet()
            }
        }
        
        var convertUserToken:String = "user_token"
        let nsUserToken = userMgr.msUserToken as String?
        if nsUserToken != nil {
            convertUserToken = nsUserToken! as String
        }
        
        var name = ""
        if isMsApp {
            name = "i-Musician"
        }else if isMpApp{
            name = "i-MusicShopper"
        }
        
        let httpHeaders = [
            "MS-Session-Id": convertUserToken,
            "Channel-ID": "Store",
            "App-Version": appVersion,
            "OS-Version": deviceMgr.systemVersion(),
            "Platform": deviceMgr.model(),
            "UUID": deviceMgr.udid(),
            "Lat": lat,
            "Lng": lng,
            "MS-Param-Hash":self.generateHashVerify(queryString),
            //            "City-Code":cityCode,
            "User-Id":nsuserid,
            "App-Name":name
        ]
        
        return httpHeaders
        
    }
    
    func wholeUrlWithBody(body:String)->String{
        var baseUrl = "http://120.132.56.89:8080/"
        
        if debugMgr.isOnlineUrl() == false{
            baseUrl = ""
        }
        let url = baseUrl + body
        return url
    }
    
    func get(request:MsRequestModel, callBack:(status:String, result:AnyObject?) -> Void)  {
        
        let urlEncode = self.wholeUrlWithBody(request.urlBody)
        
        afNetWorkManager.requestSerializer = AFJSONRequestSerializer() as AFJSONRequestSerializer
        let headers = self.httpHeader(request.requestParameters,isPost: false)
        
        for key in headers.allKeys {
            let value:String = headers.stringWithKey(key as! String)
            afNetWorkManager.requestSerializer.setValue(value , forHTTPHeaderField: key as! String)
        }
        afNetWorkManager.requestSerializer.timeoutInterval = 10
        afNetWorkManager.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html","application/json"]) as Set<NSObject>
        
        
        afNetWorkManager.GET(urlEncode,parameters:request.requestParameters,
            success:{(operation:AFHTTPRequestOperation!, responseObject:AnyObject!) in
                
                let status = responseObject!["status"] as? String
                if status != "ok" {
                    if responseObject != nil{
                        
                        let errorCode = responseObject!["errorCode"] as? String
                        if  errorCode == token_invalid{
                            userMgr.userLogout()
                        }
                        
                        let errorMsg = responseObject!["errorMessage"] as? String
                        SVProgressHUD .showInfoWithStatus(errorMsg)
                        //网络失败和后天返回失败，都属于失败
                        callBack(status: "fail",result:nil)
                        return
                    }
                }
                
                callBack(status: "ok",result: responseObject)
                
            },
            failure:{(operation, error) in
                SVProgressHUD .showInfoWithStatus("网络燥累了,请稍候再试...")
                callBack(status: "fail",result:error)
            }
        )
    }
    
    func post(request:MsRequestModel,  callBack:(status:String, result:AnyObject?) -> Void)  {
        
        let urlEncode = self.wholeUrlWithBody(request.urlBody)
        afNetWorkManager.requestSerializer = AFJSONRequestSerializer() as AFJSONRequestSerializer
        let headers = self.httpHeader(request.requestParameters,isPost: true)
        
        for key in headers.allKeys {
            let value:String = headers.stringWithKey(key as! String)
            afNetWorkManager.requestSerializer.setValue(value , forHTTPHeaderField: key as! String)
        }
        
        afNetWorkManager.requestSerializer.timeoutInterval = 10
        afNetWorkManager.responseSerializer.acceptableContentTypes = NSSet(array: ["text/html","application/json"]) as Set<NSObject>
        
        afNetWorkManager.POST(urlEncode, parameters: request.requestParameters, success:{(operation:AFHTTPRequestOperation!, responseObject:AnyObject!) in
            
            let status = responseObject!["status"] as? String
            if status != "ok" {
                if responseObject != nil{
                    
                    let errorCode = responseObject!["errorCode"] as? String
                    if  errorCode == token_invalid{
                        userMgr.userLogout()
                    }
                    
                    let errorMsg = responseObject!["errorMessage"] as? String
                    SVProgressHUD .showInfoWithStatus(errorMsg)
                    //网络失败和后天返回失败，都属于失败
                    callBack(status: "fail",result:nil)
                    return
                }
            }
            
            callBack(status: "ok",result: responseObject)
            },
            failure:{(operation, error) in
                SVProgressHUD .showInfoWithStatus("网络燥累了,请稍候再试...")
                callBack(status: "fail",result:error)
            }
        )
        
    }
    
    
    
    //图片处理
    func updateLoadImage(data:NSData){
        let qnMgr =  QNUploadManager()
//        qnMgr.putData(<#T##data: NSData!##NSData!#>, key: <#T##String!#>, token: <#T##String!#>, complete: <#T##QNUpCompletionHandler!##QNUpCompletionHandler!##(QNResponseInfo!, String!, [NSObject : AnyObject]!) -> Void#>, option: <#T##QNUploadOption!#>)

    }
    
    
    
    //verify hash
    func generateHashVerify(queryString:String) -> String {
        var string = ""
        if isMsApp{
            string = "\(queryString)rT|ioLh~++G^-V- +iEBdusy9rBDJ%CgIdxmxFNchlm+ekJnblCMJADL07D2"
        }else if isMpApp{
            string = "\(queryString)gIdxmxFNchlm+ekJnblCMJADL07D2rT|ioLh~++G^-V- +iEBdusy9rBDJ%C"
            //chenglong
            string = "\(queryString)rT|ioLh~++G^-V- +iEBdusy9rBDJ%CgIdxmxFNchlm+ekJnblCMJADL07D2"

        }
        string = string.md5
        return string
    }
    
    
}