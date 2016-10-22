
//  MpOrderShowMainViewController.swift
//  MusicShare
//
//  Created by poleness on 16/1/30.
//  Copyright © 2016年 poleness. All rights reserved.
//

import UIKit
import SVProgressHUD


//商家查看订单状态
let STATE_ALL = 0   //全部
let STATE_PAYING = 1//待支付
let STATE_ING = 2   //进行中
let STATE_EVA = 3   //待评价
let STATE_END = 4   //已结束（包括结束和取消）

class MpOrderShowMainViewController: MsBaseViewController,MpNormalOrderListViewDelegate,MpResidentOrderListViewDelegate,MpOrderTypeTableViewDelegate,MpPerformanceTableViewDelegate ,MpNeedLoginViewDelegate{
    
    //UI
    var normalOrderView:MpNormalOrderListTableView?
    var residentOrderView:MpResidentOrderListTableView?
    var performanceView:MpPerformanceListTableView?
    
    var typeTableView:MpOrderTypeTableView?
    
    //not login
    var needLoginView:MpNeedLoginView?
    
    //nav
    var navButton:UIButton?
    var navView:UIView?
    var navImage:UIImageView?
    
    //data
    var dataArray = NSArray() //包含所有refreshmodel
    var currentType:Int = 0 //当前选择的type
    var currentState:Int = 0 //当前的state
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        self.initData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self .setNavigationShopperImage()
        
        self.checkDefaultViewIfNeed()
        self.updateCurrentStateData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initView(){
        self.edgesForExtendedLayout = UIRectEdge.Top
        self .setNavigationTitle("订单")
        self.view.backgroundColor = UIColor.msBackGroundColor()
        
        //nav
        self.navButton = UIButton(frame: CGRectMake(kScreenWidth / 2 - 140 / 2,0,120,44)) //左偏移50
        self.navButton?.titleLabel?.font = UIFont.systemFontOfSize(17)
        self.navButton!.addTarget(self, action: Selector("navButtonTouchedAction"), forControlEvents: UIControlEvents.TouchUpInside)
        self.navImage = UIImageView(frame: CGRectMake(kScreenWidth / 2 + 30, 44 / 2 - 10 / 2, 15, 10))
        self.navImage?.image = UIImage(named: "down_arrow_solid_white")
        
        self.navView = UIView(frame: CGRectMake(0,0,kScreenWidth,44))
        self.navView!.addSubview(self.navButton!)
        self.navView!.addSubview(self.navImage!)
        self.navView!.userInteractionEnabled = true
        
        self.navigationItem.titleView = self.navView
        
        self.updateNavigation(OrderType.normal)//默认为normal
        
        self.normalOrderView = MpNormalOrderListTableView(frame: CGRectMake(0,0,kScreenWidth,kScreenHeight - 50 - 64 ))
        self.normalOrderView?.delegate = self
        self.view .addSubview(self.normalOrderView!)
        
        self.residentOrderView = MpResidentOrderListTableView(frame:self.normalOrderView!.bounds)
        self.residentOrderView?.delegate = self
        self.view.addSubview(self.residentOrderView!)
        
        self.performanceView = MpPerformanceListTableView(frame: CGRectMake(0,0,kScreenWidth,kScreenHeight - 50 - 64))
        self.performanceView?.delegate = self
        self.view.addSubview(self.performanceView!)
        
        self .updateNavigation(OrderType.normal)
        
        //这个必须在最顶层面
        self.initTypeTableView()
        
    }
    
    
    func initTypeTableView(){
        let frame = UIScreen.mainScreen().bounds
        self.typeTableView = MpOrderTypeTableView(frame:frame)
        self.typeTableView?.hidden = true
        self.typeTableView?.delegate = self
        self.view .addSubview(self.typeTableView!)
    }
    
    func initData(){
        self.currentType = OrderType.normal
        self.currentState = STATE_ALL
        
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
    
    func updateNavigation(navType:Int){
        var title = ""
        self.currentType = navType
        
        self.normalOrderView?.hidden = true
        self.residentOrderView?.hidden =  true
        self.performanceView?.hidden = true
        
        if navType == OrderType.normal {
            title = "演出订单"
            self.normalOrderView?.hidden = false
        }else if navType == OrderType.resident{
            title = "驻场订单"
            self.residentOrderView?.hidden =  false
        }else{
            title = "演出活动"
            self.performanceView?.hidden = false
        }
        
        self.navButton!.setTitle(title, forState: UIControlState.Normal)
        self.navButton!.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    /**
    * delegate
    */
    //普通订单
    func refreshNormalOrderList(state:Int,isLoadMore:Bool){
        
        for item in self.dataArray{
            let model = item as! MpRefreshOrderModel
            if model.orderType == OrderType.normal && model.state == state{
                if isLoadMore && model.currentPage + 1 > model.totalPage{
                    self.normalOrderView!.updateData(model,isFinished: true)

                    break
                }
                self.requestForNormalData(model,isLoadMore: isLoadMore)
                break
            }
        }
    }
    
    func didSelectNormalOrder(order:NormOrderModel){
        let subVC = MpOrderDetailViewController()
        subVC.mpOrder = order
        self .hidePushViewController(subVC, animated: true)
    }
    
    
    //驻场
    func refreshResidentOrderList(){
        
    }
    func loadModeResidentOrderList(){
        
    }
    
    
    //没有登录
    func enterLoginView(){
        let subVC = MpLoginViewController()
        subVC.viewSource = ShopLoginSource.FromPresent
        let nav = UINavigationController(rootViewController: subVC)
        self.presentViewController(nav, animated: true, completion: nil)
    }
    
    
    
    /**
     *  Action
     */
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
    
    
    //nav changed
    func navButtonTouchedAction(){
        if userMgr.isLogin() == false{
            SVProgressHUD .showInfoWithStatus("请先登录")
        }
        if self.typeTableView!.hidden == true{
            self.typeTableView?.setOrderTypeShow(true)
        }else{
            self.typeTableView?.setOrderTypeShow(false)
        }
    }
    
    func didselectOrderType(type:Int){
        self.updateNavigation(type)
        self.requestForData(type, state: 0)
    }
    
    
    
    func refreshWholeOrderListData(){
        
    }
    
    func loadModeWholeOrderListData(){
        
    }
    
    
    func refreshPerformanceData(){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), { () -> Void in
            self.performanceView!.updateData(self.dataArray)
        });
    }
    func loadModePerformanceData(){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), { () -> Void in
            self.performanceView!.updateData(self.dataArray)
        });
    }
    
    //network
    func requestForData(navType:Int,state:Int){
        
    }
    
    
    func requestForNormalData(model:MpRefreshOrderModel,isLoadMore:Bool){
        
        if userMgr.isLogin() == false{
            return
        }
        
        if isLoadMore == false{
            model.currentPage = 1
        }else{
            model.currentPage++;
        }
        
        let userId = userMgr.userInfo.userId
        let request = MsRequestModel.requestForShopNormalOrderList(userId,page:String(model.currentPage), state: String(model.state))
        netWorkMgr.post(request) { (status, result) -> Void in
            if status == "ok"{
                if result != nil{
                    let playBoard: NSDictionary = (result!["payload"] as? NSDictionary)!
                    let orderList:NSArray = playBoard .objectForKey("content") as! NSArray
                    model.totalPage = Int(playBoard .stringWithKey("total"))!
                    
                    var array_M = NSMutableArray()
                    if isLoadMore {
                        array_M = NSMutableArray(array: model.dataArray)
                    }
                    
                    if orderList.count > 0 {
                        for item in orderList{
                            if item .isKindOfClass(NSDictionary){
                                let model = NormOrderModel(orderData:item as! NSDictionary)
                                array_M .addObject(model)
                            }
                        }
                    }
                    model.dataArray = array_M
                    self.normalOrderView!.updateData(model,isFinished:false)
                    //正常情况
                    return
                }
            }
            
            //default （or failure）
            if isLoadMore == true{
                model.currentPage--;
            }
            self.normalOrderView!.updateData(model,isFinished:false)
        }
    }
    
    
    //default View
    func checkDefaultViewIfNeed(){
        if userMgr.isLogin(){
            if self.needLoginView != nil{
                self.needLoginView!.removeFromSuperview()
                self.needLoginView = nil
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
    
}
