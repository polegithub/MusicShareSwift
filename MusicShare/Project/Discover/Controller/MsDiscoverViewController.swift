//
//  MsDiscoverViewController.swift
//  MusicShare
//
//  Created by poleness on 15/12/2.
//  Copyright © 2015年 poleness. All rights reserved.
//

import UIKit
import SVProgressHUD

class MsDiscoverViewController: MsBaseViewController,MsDiscoverTableViewDelegate,MsLocationSearchViewDelegate,MpNeedLoginViewDelegate {
    
    var dataArray = NSArray()
    
    var page = 0
    var totalPage = 0
    
    //UI
    var disTableView: MsDiscoverTableView!
    var defaultView:UIView!
    var navTitle:UIButton!
    
    var needLoginView:MpNeedLoginView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationTitle("发现")
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        self.initView()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.hidesBottomBarWhenPushed = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationMusicianImage()
        
        self.checkDefaultViewIfNeed()
        
        var animation = true
        if self.dataArray.count > 0 {
            animation = false
        }
        self .requestForDataWithType(refreshType.refresh,animation:animation)
        
    }
    
    func initView(){
        self.disTableView = MsDiscoverTableView(frame: CGRectMake(0,0,kScreenWidth,kScreenHeight - 64 - 50))
        self.disTableView.delegate = self
        
        self.view .addSubview(self.disTableView)
        
        self.navTitle = UIButton(frame: CGRectMake(0,0,kScreenWidth,44))
        self.navTitle .setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.navTitle .addTarget(self, action: Selector("enterLocationViewAction"), forControlEvents: UIControlEvents.TouchUpInside)
        self.navTitle.titleLabel?.font = UIFont.systemFontOfSize(15)
        self.navigationItem.titleView = self.navTitle
        
        self.initDefaultView()
        
        self.userUpdatedLocation("")
    }
    
    
    func initDefaultView(){
        self.defaultView = UIView(frame: CGRectMake(0,0,kScreenWidth,kScreenHeight))
        
        self.defaultView.backgroundColor = UIColor.msBackGroundColor()
        
        let label = UILabel(frame: CGRectMake(0,kScreenHeight * 0.4,kScreenWidth,44))
        label.text = "暂无新乐单"
        label.textColor = UIColor.lightGrayColor()
        label.font = UIFont.systemFontOfSize(15)
        label.textAlignment = NSTextAlignment.Center
        
        self.defaultView .addSubview(label)
        self.disTableView .addSubview(self.defaultView)
    }

    
    /**
    * 进入子页面
    */
    func enterLocationViewAction(){
        let subVC = MsLocationSearchViewController()
        subVC.deledate = self
        self .hidePushViewController(subVC, animated: true)
    }
    
    //MsLocationSearchViewDelegate
    func userUpdatedLocation(locationText:String){
        //更新位置
        if locationText.isEmpty{
            self.navTitle .setTitle("请输入您的位置 >", forState: UIControlState.Normal)
            return
        }
        self.navTitle .setTitle(locationText, forState: UIControlState.Normal)
    }
    
    
    //MsDiscovertableviewdelegate
    func didSelectDiscoverOrderDetail(order: NormOrderModel) {
        
        let subVC = MsOrderDetailViewController()
        subVC.type = OrderBelong.PubOrder
        subVC.orderInfo = order
        self .hidePushViewController(subVC, animated: true)
        
    }
    func refreshDiscoverData(type:Int){
        if self.totalPage < self.page + 1{
            self.disTableView.tableView?.isFinished = true
            self.disTableView .tableView?.pullTableIsLoadingMore = false
        }else{
            self.requestForDataWithType(type, animation: false)
        }
    }
    
    
    func userClickAcceptAction(orderModel:NormOrderModel){
        let alert = UIAlertController(title: "确认接单？", message: "接单后需经过发布人筛选才能最终确认订单", preferredStyle: UIAlertControllerStyle.Alert)
        
        let cancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        let confirm = UIAlertAction(title: "确认", style: UIAlertActionStyle.Default) { (action) -> Void in
            self.acceptOrderAction(orderModel)
        }
        
        alert .addAction(cancel)
        alert.addAction(confirm)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    //接单action
    func acceptOrderAction(orderModel:NormOrderModel){
        
        self.requestForGrabOrder(orderModel.orderId, timeId: orderModel.timeId)
        
    }
    
    //login
    func enterLoginView(){
        
        let subVC = MsUserTypeOptionViewController()
        subVC.viewSource = UserOptionSource.FromOther
        let nav = UINavigationController(rootViewController: subVC)
        self.presentViewController(nav, animated: true, completion: {})
    }
    
    
    
    
    //default View
    func checkDefaultViewIfNeed(){
        if userMgr.isLogin(){
            if self.needLoginView != nil{
                self.needLoginView!.removeFromSuperview()
                self.needLoginView = nil
            }
            
            //登录则检查是否有数据
            if self.dataArray.count >  0{
                self.defaultView.hidden = true
            }else{
                self.defaultView.hidden = false
            }
            
        }else{
            self.addLoginView()
        }
    }
    
    func addLoginView(){
        if self.needLoginView == nil{
            self.needLoginView = MpNeedLoginView(delegate: self)
            self.view .addSubview(self.needLoginView!)
        }else{
            if self.needLoginView!.superview != nil{
                self.view .addSubview(self.needLoginView!)
            }
        }
    }
    
    
    
    //网络请求
    func requestForDataWithType(refresh:Int,animation:Bool){
        if userMgr.isLogin() == false{
            return
        }
        
        if refresh == refreshType.refresh{
            self.page = 1
        }else{
            self.page += 1
        }
        
        if animation{
            SVProgressHUD .showWithStatus("请稍后")
        }
        
        let userId = userMgr.userInfo.userId
        
        let request = MsRequestModel.requestForMsAvailableNormalOrderList(String(self.page),userId: userId)
        netWorkMgr.post(request) { (status, result) -> Void in
            if status == "ok"{
                
                if animation {
                    SVProgressHUD .dismiss()
                }
                
                if result != nil{
                    let playBoard: NSDictionary = (result!["payload"] as? NSDictionary)!
                    let orderList:NSArray = playBoard .objectForKey("content") as! NSArray
                    self.totalPage = Int(playBoard .stringWithKey("total"))!
                    var array_M = NSMutableArray()
                    
                    if refresh == refreshType.loadMore{
                        array_M = NSMutableArray(array:self.dataArray)
                    }
                    
                    for item in orderList{
                        let model = NormOrderModel(orderData: item as! NSDictionary)
                        array_M .addObject(model)
                    }
                    
                    self.dataArray = NSArray(array: array_M)
                }
            }else{
                //default （or faileure）-?? 待确认，此方案不佳
                if refresh == refreshType.refresh{
                    self.page -= 1
                }
            }
            
            //放到这里是为了pulltableviewisRefreshing
            self.disTableView .updateDisData(self.dataArray)
            self.checkDefaultViewIfNeed()
        }
    }
    
    //接单
    func requestForGrabOrder(orderId:String,timeId:String){
        if userMgr.isLogin() == false{
            return
        }
        
        SVProgressHUD .showWithStatus("抢单中...")
        
        let userId = userMgr.userInfo.userId
        let request = MsRequestModel.requestForGrabOrder(userId,orderId:orderId,timeId:timeId)
        netWorkMgr.post(request) { (status, result) -> Void in
            if status == "ok"{
                
                SVProgressHUD .showInfoWithStatus("抢单成功")
                self.goBack()
                
                NSNotificationCenter.defaultCenter() .postNotificationName(kNotificationEnterMyorder, object: nil)
            }else{
                //                SVProgressHUD .showInfoWithStatus("很抱歉您未抢到此单")
                //未抢到，则刷新订单列表
                self.requestForDataWithType(refreshType.refresh, animation: false)
            }
        }
    }
    
    
    
}
