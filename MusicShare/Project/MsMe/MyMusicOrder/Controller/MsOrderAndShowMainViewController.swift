//
//  MsOrderAndShowMainViewController.swift
//  MusicShare
//
//  Created by poleness on 15/12/28.
//  Copyright © 2015年 poleness. All rights reserved.
//

import UIKit
import SVProgressHUD

//音乐人查看订单状态
let MS_STATE_ALL = 0   //全部
let MS_STATE_SIGN = 1  //已报名
let MS_STATE_ING = 2   //进行中
let MS_STATE_EVA = 3   //待评价
let MS_STATE_END = 4   //已结束（包括结束和取消）

class MsOrderAndShowMainViewController: MsBaseViewController,MsMyResidentStateListDelegate,MsMyNormalOrderListDelegate{
    
    let tag_resident = 1
    let tag_order = 0
    
    //UI
    var subNavView:UIView?
    var residentView :MsMyResidentStateListView?
    var orderView:MsMyNormalOrderListView?
    
    //导航segmentView
    var segmentView:UISegmentedControl?

    
    //data
    var normalPerdata = NSMutableArray()
    var orderPerData = NSMutableArray()

    //data
    var dataArray = NSArray() //包含所有refreshmodel
    var currentType:Int = 0 //当前选择的type
    var currentState:Int = 0 //当前的state
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
        self .initData()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateCurrentStateData()
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    func initData(){
        self.currentType = OrderType.normal
        self.currentState = MS_STATE_ALL
        
        let array_M = NSMutableArray()
        
        for item in 0...2{
            var stateCount = 0
            if item == OrderType.normal{
                stateCount = 5
            }else if item == OrderType.resident{
                stateCount = 3
            }else{
                stateCount = 1
            }
            for var i = 0;i < stateCount;i++ {
                let refreshModel = MpRefreshOrderModel(state:i,orderType:item )
                array_M .addObject(refreshModel)
            }
        }
        self.dataArray = NSArray(array: array_M)
    }

    func initView(){
        
        self.setNavigationTitle("我的乐单")
        self.setLeftBackImageWithWhite()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.view.backgroundColor = UIColor.msBackGroundColor()
        
        self.segmentView = UISegmentedControl(items: ["演出","驻场"])
        self.segmentView?.frame = CGRectMake(kScreenWidth/2 - 100/2, 44/2-30/2, 120, 30)
        self.segmentView?.addTarget(self, action: Selector("segmentValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        self.segmentView?.selectedSegmentIndex = 0
        self.segmentView?.tintColor = UIColor.whiteColor()
        
        self.navigationItem.titleView = self.segmentView

        // order tableView
        self.orderView = MsMyNormalOrderListView(frame:CGRectMake(0, 0, kScreenWidth, kScreenHeight ))
        self.orderView?.delegate = self
        self.orderView?.hidden = true

        self.residentView = MsMyResidentStateListView(frame: self.orderView!.frame)
        self.residentView?.delegate = self
        
        self.residentView?.hidden = true
        
        self.view .addSubview(self.residentView!)
        self.view.addSubview(self.orderView!)
        
        self .setCurrentView(tag_order)
        
    }
    
    func segmentValueChanged(segMent:UISegmentedControl){
        let index = segMent.selectedSegmentIndex
        self.setCurrentView(index)

    }
    
    func setCurrentView(index:Int){
        if index == tag_order {
            //order
            self.orderView?.hidden = false
            self.residentView?.hidden = true

//            if self.normalPerdata.count == 0 {
                //暂时做成每次都刷新
//            self.requestForNormalPerformData(false, animation: false)
//            }
        }else{
            //resident
            self.orderView?.hidden = true
            self.residentView?.hidden = false
//            if self.orderPerData.count == 0 {
            //暂时做成每次都刷新
//                self.requestForOrderListData(false,animation: false)
//            }
        }
        
    }
    
    
    
    //get init request data
    func updateCurrentStateData(){
        for item in self.dataArray {
            let model = item as! MpRefreshOrderModel
            if model.orderType == self.currentType && model.state == self.currentState{
                if self.currentType == OrderType.normal{
                    self.requestForNormalData(model, isLoadMore: false)
                }else if self.currentType == OrderType.resident{
                    
                }else{
                    
                }
            }
        }
    }
    
    
    // MARK: searchbardelegae
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        let searchVC = MsSearchMainViewController()
        self .hidePushViewController(searchVC, animated: true)
        
        return false
    }
    
    
    
    //网络请求
    func requestForNormalData(model:MpRefreshOrderModel,isLoadMore:Bool){

        if userMgr.isLogin() == false{
            return
        }
        
        if isLoadMore == false{
            model.currentPage = 1
        }else{
            model.currentPage++;
        }
        
        
        let userId  = userMgr.userInfo.userId
        
        let request = MsRequestModel.requestForMsMyNormalOrderList(userId,page:String(model.currentPage), state: String(model.state))
        
        netWorkMgr .post(request) { (status, result) -> Void in
            
            if status == "ok" {
                let content:NSDictionary = (result!["payload"] as? NSDictionary)!
                if content.count > 0 {
                    //页数
                    let pageDic = content .objectForKey("page") as?NSDictionary
                    if pageDic != nil {
                        model.totalPage = Int(pageDic!.stringWithKey("total"))!
                    }
                    
                    //data list
                    if isLoadMore == false{
                        self.normalPerdata .removeAllObjects()
                    }
                    let listData = content .objectForKey("content") as? NSArray
                    if listData != nil{
                        for item in listData!{
                            let showModel = NormOrderModel(orderData: (item as? NSDictionary)!)
                            self.normalPerdata .addObject(showModel)
                            
                        }
                    }
                }else{
                    
                }
            }else{
                
            }
            self.orderView!.updateData(self.normalPerdata)
        }
        
    }
    
    func requestForOrderListData(summation:Bool ,animation:Bool){
        //chenglong
        self.orderPerData = self.normalPerdata
//        self.orderPerformView?.updateData(self.orderPerData)
    }
    
    
    /**
     *  Action
     */

    
    //MsMyResidentStateListDelegate
    func didSelectAllResidentOrder(){
        
    }
    
    func didSelectResidentOrder(order:NormOrderModel){
        let subVC = MsOrderDetailViewController()
        subVC.type = OrderBelong.PerOrder
        subVC.orderInfo = order
        self .hidePushViewController(subVC, animated: true)
    }

    
    //normal delegate
    //普通订单
    func refreshNormalOrderList(state:Int,isLoadMore:Bool){
        for item in self.dataArray{
            let model = item as! MpRefreshOrderModel
            if model.orderType == OrderType.normal && model.state == state{
                if isLoadMore && model.currentPage + 1 > model.totalPage{
                    break
                }
                self.requestForNormalData(model,isLoadMore: isLoadMore)
                break
            }
        }
    }
    
    func didSelectNormalOrder(order:NormOrderModel){
        let subVC = MsOrderDetailViewController()
        subVC.orderInfo = order
        subVC.type = OrderBelong.PerOrder
        self .hidePushViewController(subVC, animated: true)
    }
    
    
    /**
    *  Action
    */
    
    
}
