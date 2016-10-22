//
//  MsUserTypeOptionViewController.swift
//  MusicShare
//
//  Created by poleness on 15/12/12.
//  Copyright © 2015年 poleness. All rights reserved.
//

import Foundation
import UIKit

enum UserOptionSource:Int {
    case FirstInstall = 0   //首次使用
    case FromOther = 1      //从其他常规入口进入
    case FromLogin = 2      //从登录入口进入
    
}


protocol MsUserOptionDelegate:NSObjectProtocol{
    func didselectUserOption(property:MsuserType)
}

class MsUserTypeOptionViewController: MsBaseViewController{
    
    //是否是首次
    var viewSource:UserOptionSource?
    
    //delegate
    var delegate:MsUserOptionDelegate?
    
    //data
    var userLastOption:Int = 0
    
    //UI
    var scrollView :UIScrollView?
    var musicianBtn: UIButton?
    var shopBtn: UIButton?
    var userBtn: UIButton?
    var visitorBtn:UIButton?
    
    var backgroundImg:UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationTransparent(true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.scrollView?.contentSize = CGSizeMake(kScreenWidth, kScreenHeight + 64)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initData(){
    }
    
    func initView(){
        
        let frame = UIScreen .mainScreen().bounds
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        self.scrollView = UIScrollView(frame: frame)
        self.scrollView?.backgroundColor = UIColor.clearColor()
        self.backgroundImg = UIImageView(frame: CGRectMake(0, -64, kScreenWidth, kScreenHeight+64))
        self.backgroundImg?.image = UIImage(named: "temp_11")
        self.backgroundImg?.contentMode = UIViewContentMode.ScaleAspectFill //比例不变，部分剪裁
        
        self.musicianBtn = self.baseButtonWithType(MsuserType.Musician)
        self.shopBtn = self.baseButtonWithType(MsuserType.Shopper)
        self.userBtn = self.baseButtonWithType(MsuserType.Consumer)
        self.visitorBtn = self.baseButtonWithType(MsuserType.Unknown)
        
        self.view! .addSubview(self.backgroundImg!)
        self.view! .addSubview(self.scrollView!)
        
        self.scrollView! .addSubview(self.musicianBtn!)
        self.scrollView! .addSubview(self.shopBtn!)
        self.scrollView! .addSubview(self.userBtn!)
        
        if self.viewSource == UserOptionSource.FirstInstall {
            self.scrollView!.addSubview(self.visitorBtn!)
            
        }else if self.viewSource != UserOptionSource.FirstInstall{
            self.setLeftBackImageWithWhite()
        }
        
        self .setNavigationMusicianImage()
    }
    
    
    //Unit
    func baseButtonWithType(type:MsuserType)->UIButton{
        let button  = UIButton(type: UIButtonType.System)
        button.layer.cornerRadius = 4.0
        button.layer.borderColor = UIColor.whiteColor().CGColor
        button.layer.borderWidth = 0.5
        
        var initY:Float
        var title:NSString = ""
        switch(type){
        case MsuserType.Musician:
            initY =  Float( kScreenHeight / 2 - 44 * 1.5 - 20 - 64)
            title = "我是音乐人"
            break
        case MsuserType.Shopper:
            initY =  Float( kScreenHeight / 2 - 44 / 2 - 64)
            title = "我是商家"
            break
        case MsuserType.Consumer:
            initY =  Float( kScreenHeight / 2 + 44 / 2 + 20 - 64)
            title = "我是个爱好者"
            break
            
        case MsuserType.Unknown:
            initY =  Float( kScreenHeight / 2 + 44 * 1.5 + 20 * 2 - 64)
            title = "随便看看"
            break
            
            
        }
        let frame = CGRectMake(50, CGFloat(initY), kScreenWidth-100, 44)
        button.frame = frame
        button .setTitle(title as String, forState: UIControlState.Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        button.backgroundColor = UIColor.clearColor().colorWithAlphaComponent(0.2)
        button.titleLabel?.font = UIFont.systemFontOfSize(17)
        
        button.tag = type.rawValue
        
        button .addTarget(self, action: Selector("buttonAction:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        return button
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
    button的action
    
    - parameter button: button description
    */
    func buttonAction(button:UIButton){
        let type = MsuserType(rawValue: button.tag)
        userMgr.setUserProperty(type!)
        
        if self.viewSource == UserOptionSource.FromLogin{
            if self.delegate != nil {
                self.delegate!.didselectUserOption(type!)
            }
            
            self.goBack()
            
        }else{
            
            if self.viewSource == UserOptionSource.FirstInstall {
                userMgr.setFirstLogin()
                if type == MsuserType.Unknown {
                    //首次+ 选择“随便看看” =》 返回进入首页
                    self.setTabToMainPage()
                    self.goBack()
                    return
                }
            }
            
            self.enterLoginView(type!)

        }
    }
    
    func enterLoginView(type:MsuserType){
        let loginVC = MsLoginViewController()
        loginVC.viewSource = UserLoginSource.FromMine
//        loginVC.currentType = type
        self.hidePushViewController(loginVC, animated: true)
        
    }
    
    //设置tabbar
    func setTabToMainPage(){
        let root:MsRootViewController = UIApplication.sharedApplication().keyWindow?.rootViewController as! MsRootViewController
        root.selectedIndex = 0
    }
    
    override func goBack() {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //网络请求
    func requestForUserInfo(){
        let isLogin:Bool = userMgr.isLogin()
        if isLogin == false {
            return
        }
    }
    
    
    
}
