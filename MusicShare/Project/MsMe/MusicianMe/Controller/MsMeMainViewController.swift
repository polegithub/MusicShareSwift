//
//  MsMeMainViewController.swift
//  MusicShare
//
//  Created by poleness on 15/12/2.
//  Copyright © 2015年 poleness. All rights reserved.
//

import UIKit
import SVProgressHUD

let LoginSection = 0
let ShowSection = 1
let PrivateSection = 2
let CertiSection = 3  //资质
let SettingSection = 4

class MsMeMainViewController: MsBaseViewController, UITableViewDataSource,
UITableViewDelegate{
    
    //data
    var dataSource = NSMutableArray()
    
    var tableView: UITableView!
    //菜单需要动态时时调整
    var menuArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.hidesBottomBarWhenPushed = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationMusicianImage()
        self.setNavigationTransparent(false)
        self.requestForUserInfo() //涉及到状态审核等信息，所以每次都刷新
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initData(){
    }
    
    func initView(){
//        let imgView = UIImageView(frame: self.view.bounds)
//        imgView.image = UIImage(named: "temp_10")
//        let blur = UIBlurEffect(style: UIBlurEffectStyle.Light)
//        let blurView = UIVisualEffectView(effect: blur)
//        blurView.frame = (imgView.bounds)
//        imgView .addSubview(blurView)
//        
//        self.view.addSubview(imgView)
        
        self.view.backgroundColor = UIColor.msBackGroundColor()
        
        self.tableView = UITableView(frame: CGRectMake(0, 0, kScreenWidth, kScreenHeight - 49 - 64), style :.Grouped)
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        self.tableView.backgroundColor = UIColor.clearColor()
//        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.
        
        self.view .addSubview(self.tableView!)
        
        self .setNavigationTitle("我的")
        self .setNavigationMusicianImage()
        
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    ///
    /// UITableViewDataSource
    ///
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == LoginSection{
            return 0.1
        }
        return 15
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var num = 0
        
        switch(section){
            
        case LoginSection:
            num = 1
            break
        case ShowSection:
            num = 2
            break
        case PrivateSection:
            num = 1
            break
        case CertiSection:
            num = 1
            break
        case SettingSection:
            num = 2
            break
            
        default:
            num  = 2
        }
        
        return num
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "orderDetailTransporterInfoTel"
        
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        
        if (cell == nil) {
            if indexPath.section == LoginSection{
                cell = UITableViewCell(style:UITableViewCellStyle.Subtitle, reuseIdentifier:cellIdentifier)
            }else{
                cell = UITableViewCell(style:UITableViewCellStyle.Value1, reuseIdentifier:cellIdentifier)
            }
            
        }
        
        cell?.contentView .removeAllSubviews()

        
        cell!.textLabel!.font = UIFont.systemFontOfSize(15.0)
        cell!.detailTextLabel?.font = UIFont.systemFontOfSize(14.0)
        
        cell?.textLabel?.textColor = UIColor.blackColor()
        cell?.detailTextLabel?.textColor = UIColor.blackColor()
        
        cell?.textLabel?.text = ""
        cell?.imageView?.image = nil
        
        cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        
        if indexPath.section == LoginSection {
            
//            //模糊背景
//            let blur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
//            let blurView = UIVisualEffectView(effect: blur)
//            blurView.frame = (cell?.bounds)!
//            cell?.backgroundView = blurView

            let userPhoto = UIImageView(frame: CGRectMake(cellLeftMargin, 84/2 - 44/2, 44, 44))
            userPhoto.layer.borderWidth = 2
            userPhoto.layer.borderColor = UIColor.grayColor().CGColor
            userPhoto.clipsToBounds = true
            userPhoto.layer.cornerRadius = 22
            
            let userName = UILabel(frame: CGRectMake(cellLeftMargin + 60, 84/2 - 30/2,200,30))
            userName.textAlignment = NSTextAlignment.Left
            userName.font = UIFont.systemFontOfSize(17)
            userName.textColor = UIColor.blackColor()
            
            if userMgr.isLogin() {
                userPhoto.image = UIImage(named: "temp_9")
                
                if userMgr.userInfo.nickName != nil {
                    userName.text = NSString(format: "%@", userMgr.userInfo.nickName!) as String
                }else{
                    let type = userMgr.userInfo.userProperty
                    if type == MsuserType.Musician {
                        userName.text = "Anthony：Musician"
                    }else if type == MsuserType.Shopper{
                        userName.text = "Anthony:Boss"
                    }else{
                        userName.text = "Anthony：Player"
                    }
                }
            }else{
                userPhoto.image = UIImage(named: "me_account")
                userName.text = "登录"
            }
            
            
//            UIColor.textAutoFitBackGroundColor(userName)
            
            cell?.contentView .addSubview(userPhoto)
            cell?.contentView.addSubview(userName)
            
        }else{
            let dic = MsMeTitleModel.titleWithIndexPath(indexPath)
            
            cell!.textLabel!.text = dic.stringWithKey(keyMeCellTitle)
            cell!.imageView!.image = UIImage(named: dic.stringWithKey(keyMeCellImage) )
            if userMgr.isLogin(){
                cell!.detailTextLabel!.text = dic.stringWithKey(keyMeCellSubTitle)
            }else{
                cell?.detailTextLabel?.text = ""
            }
        }
        
        
        
        return cell!
    }
    
    ///
    /// UITableViewDelegate
    ///
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 && indexPath.section == 0{
            return 84
        }
        return  44
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView .deselectRowAtIndexPath(indexPath, animated:true )
        let isLogin = userMgr.isLogin()
        //        let currentType = userMgr.userProperty
        
        switch(indexPath.section){
        case LoginSection:
            if isLogin {
                self.enterMyView()
            }else{
                self.enterLoginView()
            }
            
            break
        case ShowSection:
            if isLogin {
                if indexPath.row == 0{
                    self.enterMyTimeLineView()
                }else if indexPath.row == 1{
                    self.enterMyFollowView()
                }
            }else{
                self.enterLoginView()
            }
            break
        case PrivateSection:
            if isLogin {
                
                if indexPath.row == 0 {
                    self.enterOrderView()
                }
            }else{
                self.enterLoginView()
            }
            break
        case CertiSection:
            if isLogin {
                self.enterMyCertificate()
            }else{
                self.enterLoginView()
            }
            break
        case SettingSection:
            if indexPath.row == 0 {
                let subVC = MsSettingViewController()
                self.hidePushViewController(subVC, animated: true)
            }
            break
        default:
            break
        }
        
    }
    
    /**
     Action
     */
     //登录
    func enterLoginView(){
        
        if userMgr.userInfo.userProperty != MsuserType.Unknown {
            let loginVC = MsLoginViewController()
            loginVC.viewSource = UserLoginSource.FromMine
//            loginVC.currentType = userMgr.userInfo.userProperty
            self.hidePushViewController(loginVC, animated: true)
        }else{
            let subVC = MsUserTypeOptionViewController()
            subVC.viewSource = UserOptionSource.FromOther
            let nav = UINavigationController(rootViewController: subVC)
            self.presentViewController(nav, animated: true, completion: {})
            
        }
        
        
        
        //        self .presentViewController(login, animated: true, completion: { () -> Void in
        //        })
    }
    
    //进入我的页面
    func enterMyView(){
        let subVC = MsMeDetailViewController()
        self.hidePushViewController(subVC, animated: true)
    }
    
    //我的订单
    func enterOrderView(){
        let subVC = MsOrderAndShowMainViewController()
        self.hidePushViewController(subVC, animated: true)
    }
    
    //我的相册
    func enterMyTimeLineView(){
        let subVC = MsTimelineViewController()
        subVC.source = TimelineSource.FromMe
        self.hidePushViewController(subVC, animated: true)
    }
    
    //我的关注
    func enterMyFollowView(){
        let subVC = MsMyFollowViewController()
        self.hidePushViewController(subVC, animated: true)
    }
    
    
    //资格审核
    func enterMyCertificate(){
        let subVC = QualCertificateMainViewController()
        self.hidePushViewController(subVC, animated: true)
    }
    
    //网络请求
    func requestForUserInfo(){
        let isLogin:Bool = userMgr.isLogin()
        if isLogin == false {
            self.tableView!.reloadData()
            return
        }
        
        let request = MsRequestModel.requestForUserBriefInfo()
        netWorkMgr.get(request) { (status, result) -> Void in
            
            if status == "ok" {
                let content:NSDictionary = (result!["payload"] as? NSDictionary)!
                
                let userModel = MsUserModel(userInfo: content)
                userMgr.updateUserInfo(userModel)
            }
        }
        
        self.tableView .reloadData()
        
    }
    
    
}