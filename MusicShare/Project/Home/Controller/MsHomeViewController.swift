//
//  MsHomeViewController.swift
//  MusicShare
//
//  Created by poleness on 15/12/2.
//  Copyright © 2015年 poleness. All rights reserved.
//

import UIKit
import SVProgressHUD


class MsHomeViewController: MsBaseViewController,UISearchBarDelegate,HomeTableViewDelegate {
    
    //    var bannerArray = NSArray()
    var navArray = NSArray()
    var dataArray = NSMutableArray()
    
    var page = 0
    var totalPage = 0
    
    var homeTableView:MsHomeTableView?
    //UI
    var searchBar: UISearchBar?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
        
        self.requestForBanner()
        self.requestForNavType()
        
        self .requestFotData(true,incremantal: false)
        
        // Do any additional setup after    loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.homeTableView?.tableView?.pullTableIsRefreshing = false
        self.homeTableView?.tableView?.pullTableIsLoadingMore = false
        
        self .setNavigationMusicianImage()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.hidesBottomBarWhenPushed = false
    }
    
    func initView(){
        
        self.searchBar = UISearchBar()
        self.searchBar?.delegate = self
        self.navigationItem.titleView = self.searchBar
        self.searchBar?.placeholder = "点击搜索您想要的乐谱，乐器，乐手"
        
        self.homeTableView = MsHomeTableView(frame: CGRectMake(0,0,kScreenWidth,kScreenHeight - 50.0 - 64))
        self.homeTableView?.delegate = self
        self.view .addSubview(self.homeTableView!)
        
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    
    // MARK: searchbardelegae
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        let searchVC = MsSearchMainViewController()
        self .hidePushViewController(searchVC, animated: true)
        
        return false
    }
    
    /**
     * 进入子页面
     */
     
     //进入导航
    func didSelectNav(tag:Int){
        let subVC = MsGoodsListViewController()
        if tag < self.navArray.count{
            let navModel  = self.navArray.objectAtIndex(tag) as! MsNavModel
            subVC.navTitle = navModel.navName
        }
        self .hidePushViewController(subVC, animated: true)
    }
    
    
    //网络请求
    func requestFotData(animation:Bool,incremantal:Bool){
        //        if incremental{
        //            self.page >= self.totalPage
        //            return
        //        }else{
        //            self.page++
        //        }
        
        if incremantal == false{
            self.dataArray .removeAllObjects()
        }
        
        //        SVProgressHUD .showInfoWithStatus("", maskType: SVProgressHUDMaskType.Clear)
        
        
        for (var i=0; i<2;i++){
            
            let array_M  = NSMutableArray()
            for (var j = 0;j < 4;j++){
                if j % 2 == 0{
                    let dic = NSMutableDictionary()
                    dic.setObject("[xx乐队]最新单曲，抢先收听", forKey: "text")
                    let temp = NSString(format: "temp_%d", arc4random_uniform(12) + 1)
                    dic.setObject(temp, forKey: "image")
                    array_M .addObject(dic)
                }else{
                    let dic = NSMutableDictionary()
                    dic.setObject("xxx演出，劲爆来袭", forKey: "text")
                    let temp = NSString(format: "temp_%d", arc4random_uniform(12) + 1)
                    dic.setObject(temp, forKey: "image")
                    array_M .addObject(dic)
                    
                }
            }
            
            //            self.menuArray .addObject(array_M)
        }
        
        self.homeTableView?.navArray = self.navArray
        
        self.homeTableView?.tableView?.reloadData()
    }
    
    
    //请求banner
    func requestForBanner(){
        let request = MsRequestModel.requestForBanner()
        
        netWorkMgr.post(request) { (status, result) -> Void in
            if status == "ok"{
                let content:NSArray = (result!["payload"] as? NSArray)!
                let array = NSMutableArray()
                if content.count > 0 {
                    for item in content{
                        let banner:MsBannerModel = MsBannerModel(dataDic:item as! NSDictionary)
                        array .addObject(banner)
                    }
                    
                    let data = NSKeyedArchiver.archivedDataWithRootObject(array)
                    NSUserDefaults .standardUserDefaults().setValue(data, forKey: kuserDefaultBannerData)
                    self.homeTableView?.updateBanner()
                }
            }
        }
    }
    
    //请求导航type
    func requestForNavType(){
        let request = MsRequestModel.requestForNavType()
        
        netWorkMgr.post(request) { (status, result) -> Void in
            if status == "ok"{
                let content:NSArray = (result!["payload"] as? NSArray)!
                let array = NSMutableArray()
                if content.count > 0 {
                    for item in content{
                        let nav:MsNavModel = MsNavModel(dataDic:item as! NSDictionary)
                        array .addObject(nav)
                    }
                    
                    self.navArray = NSArray(array: array)
                    self.homeTableView?.navArray = array
                    self.homeTableView?.tableView?.reloadData()
                }
            }
        }
    }
    
    
    func refreshHomeData(){
        self.requestFotData(false, incremantal: false)
    }
    func reloadMoreHomeData(){
        self.requestFotData(false, incremantal: false)
    }
    
}
