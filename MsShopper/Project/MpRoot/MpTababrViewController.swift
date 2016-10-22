//
//  MpTababrViewController.swift
//  MusicShare
//
//  Created by poleness on 16/1/19.
//  Copyright © 2016年 poleness. All rights reserved.
//

import UIKit

class MpTababrViewController: UITabBarController {

    var home:MsHomeViewController?
    var order:MpOrderShowMainViewController?
    var timeline:MpTimelineViewController?
    var me:MpMeViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 界面布局
        configureLayout()
        // 初始化控制器
        configureControllers()
        
//        if userMgr.hasShowLogin != true {
//            self.selectedIndex = 3
//            self.selectedViewController?.view.hidden = true
//        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
//        self.showLoginIfNeed()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureLayout() {
        self.automaticallyAdjustsScrollViewInsets = false
        //        self.view.backgroundColor = UIColor.msCommonColor()
        
        //        self.view.backgroundColor = UIColor.blackColor()
        //        self.view.alpha = 0.5
        
    }
    
    func configureControllers() {
        self.home = MsHomeViewController()
        let homeNav = UINavigationController(rootViewController: self.home!)
        homeNav.title = "首页"
        
        self.order = MpOrderShowMainViewController()
        let orderNav = UINavigationController(rootViewController: self.order!)
        orderNav.title = "订单"
        
        self.me = MpMeViewController()
        let meNav = UINavigationController(rootViewController: self.me!)
        meNav.title = "我的"
        
        self.timeline = MpTimelineViewController()
        self.timeline?.source = TimelineSource.FromTabbar
        let concernNav = UINavigationController(rootViewController:self.timeline!)
        concernNav.title = "关注"
        
        let middle = UIViewController()
        let controllers = [homeNav,orderNav,middle,concernNav,meNav]
        self .setViewControllers(controllers, animated: true)
        
        let middleView = self.middleButton()
        self.tabBar .addSubview(middleView)

        
//        self.tabBar.barStyle = UIBarStyle.Black
//        self.tabBar.translucent = true
        //        self.tabBar.barTintColor = UIColor.blackColor()
        //        self.tabBar.backgroundImage = UIImage() //设置透明
//        self.tabBar.tintColor = UIColor.msCommonColor()
        
    }
    

    //中间的button
    func middleButton()->UIView{
        let width:CGFloat = CGFloat(kScreenWidth / 5)
        let initX :CGFloat = CGFloat(width * 2)
        let view  = UIView(frame: CGRectMake(initX,-20,width,50 + 20 ))
        
        let button = UIButton(frame: CGRectMake(width/2 - 60/2,0,60,60))
        button.layer.cornerRadius = 30
        button.clipsToBounds = true
        button.backgroundColor = UIColor.redColor()
        button .setImage(UIImage(named: "temp_2"), forState: UIControlState.Normal)
        
        button .addTarget(self, action: Selector("showOrderIssueView"), forControlEvents: UIControlEvents.TouchUpInside)
        
        let touchButton = UIButton(frame: CGRectMake(0,20,width,50))
         touchButton .addTarget(self, action: Selector("showOrderIssueView"), forControlEvents: UIControlEvents.TouchUpInside)
        
        view .addSubview(button)
        view .addSubview(touchButton)
        
        return view
    }
    
    func showOrderIssueView(){
        
        if userMgr.isLogin(){
            let  subVC = MpIssueChooseViewController()
            let nav = UINavigationController(rootViewController: subVC)
            self.presentViewController(nav, animated: true, completion: nil)
        }else{
            let subVC = MpLoginViewController()
            subVC.viewSource = ShopLoginSource.FromPresent
            let nav = UINavigationController(rootViewController: subVC)
            self.presentViewController(nav, animated: true, completion: nil)
        }

    }

}
