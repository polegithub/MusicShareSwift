//
//  MsOrderListViewController.swift
//  MusicShare
//
//  Created by poleness on 15/12/28.
//  Copyright © 2015年 poleness. All rights reserved.
//

import UIKit

class MpOrderAndShowMainViewController: MsBaseViewController,MsTopBarViewDelegate{

    var dataArray = NSArray()
    
    var page = 0
    var totalPage = 0
    
//    var residentView:MsMyResidentStateListView?
//    var orderView:MsMyOrderStateListView?
    
    let cellIdentifier = "MpOrderAndShowMainViewControllerCell"
    
    //UI
    var tableView: UITableView?
    
    var segmentView:UISegmentedControl?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
        self.initData()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.hidesBottomBarWhenPushed = false

        self.setNavigationDefaultImage()
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    func initView(){
        
        self.edgesForExtendedLayout = UIRectEdge.None
        
        self.setNavigationShopperImage()
        
        self.setNavigationTitle("我的订单")
        self.setLeftBackImageWithWhite()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.view.backgroundColor = UIColor.msBackGroundColor()
        
//        let type = userMgr.userInfo.userProperty
//        if type == MsuserType.Shopper {
            let right = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Search, target: self, action: Selector("enterNewPerformanceView"))
            self.navigationItem.rightBarButtonItem = right
//        }
        
//        self.residentView = MsMyResidentStateListView(frame: CGRectMake(0,0,kScreenWidth,kScreenHeight - 64))
//        
//        self.view .addSubview(self.residentView!)
        
    }

    func initData(){
        
        let array = NSMutableArray()
        for _  in 1...5 {
            let showModel = MpOrderModel(orderData: NSDictionary())
            array .addObject(showModel)
        }
        
//        self.residentView!.updateData(array)
    }
    
    
    func segmentValueChanged(segMent:UISegmentedControl){
        let index = segMent.selectedSegmentIndex
        self.setCurrentView(index)
        
    }
    func setCurrentView(index:Int){
        //右侧 + 仅商家可以发布演出，仅音乐人/商家 可以发布订单
//        self.updateRightItem()
        
        if index == 0 {
            
        }else{
    
        }
        
    }

        
    
    // MARK: searchbardelegae
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
//        let searchVC = MsSearchMainViewController()
//        self .hidePushViewController(searchVC, animated: true)
//        
        return false
    }
    
    
    
    //网络请求
    func requestForData(){
//        let request = MsRequestModel.requestForUserShowList(String(self.page))
//        
//        netWorkMgr .post(request) { (status, result) -> Void in
//                    if status == "ok" {
//                        let content:NSDictionary = (result!["payload"] as? NSDictionary)!
//                        if content.count > 0 {
//                            //页数
//                            let pageDic = content .objectForKey("page") as?NSDictionary
//                            if pageDic != nil {
//                                self.totalPage = Int(pageDic!.stringWithKey("total"))!
//                            }
//                            
//                            //data list
//                            let listData = content .objectForKey("content") as? NSArray
//                            if listData != nil{
//                                let array_M = NSMutableArray()
//                                for  item in listData!{
//                                    let showModel = MpOrderModel(showListData: (item as? NSDictionary)!)
//                                    array_M .addObject(showModel)
//                                }
//                                self.dataArray = array_M
//                            }
//                        }else{
//                            
//                        }
//                
//            }
//            
//            self.tableView?.reloadData()
//            
//        }
//        
//        let array_M  = NSMutableArray()
//
//                for (var i=0; i<10;i++){
//        
//                           let showModel = MpOrderModel(showListData: NSDictionary())
//         
//                            array_M .addObject(showModel)
//
//                    }
//        
//        self.dataArray = array_M
//        self.tableView?.reloadData()
        
    }
    
    //更新数据
    func updateData(data:NSArray){
        self.dataArray = data
        self.tableView!.reloadData()
        
        self.requestForData()
        
    }
    
    
    /**
     *  Action
     */
    
    func enterNewPerformanceView(){
//        let subVC = MpCreatePerormOrderViewController()
//        self.hidePushViewController(subVC, animated: true)
    }
    
    //MsTopBarViewDelegate
    func didSelectedTopbar(index: Int) {
//        let array = NSMutableArray()
//        
//        let temp:CGFloat = (CGFloat(arc4random_uniform(10)) + 10.0) / 30.0
//        for _  in 1...index + 5 {
//            let showModel = MsShowModel(showListData: NSDictionary())
//            showModel.process = temp
//            array .addObject(showModel)
//        }
//        
//        self.orderPerformView!.updateData(array)
    }
    
    

}
