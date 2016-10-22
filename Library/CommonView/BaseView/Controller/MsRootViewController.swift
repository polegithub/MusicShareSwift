//
//  MsRootViewController.swift
//  MusicShare
//
//  Created by poleness on 15/12/1.
//  Copyright © 2015年 poleness. All rights reserved.
//

import UIKit

///
/// 标签栏按钮的起始标签Tag值
///
let kBarItemStartTag = 100

let homeIndex = 0
let disIndex = 1
let timeIndex = 2
let meIndex = 3

class MsRootViewController: UITabBarController {
    
    ///
    /// 成员变量声明
    ///
    var tabBarView: UIView? // 定制标签栏tabbar
    
    var home:MsHomeViewController?
    var discover:MsDiscoverViewController?
    var timeline:MsTimelineViewController?
    var me:MsMeMainViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 界面布局
        configureLayout()
        // 初始化控制器
        configureControllers()
        
        if userMgr.hasShowLogin != true {
            self.selectedIndex = 3
            self.selectedViewController?.view.hidden = true
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.showLoginIfNeed()
        
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
        
        self.discover = MsDiscoverViewController()
        let discoverNav = UINavigationController(rootViewController: self.discover!)
        discoverNav.title = "演出"
        
        self.me = MsMeMainViewController()
        let meNav = UINavigationController(rootViewController: self.me!)
        meNav.title = "我"
        
        self.timeline = MsTimelineViewController()
        self.timeline?.source = TimelineSource.FromTabbar
        let concernNav = UINavigationController(rootViewController:self.timeline!)
        concernNav.title = "关注"
        
        let controllers = [homeNav,discoverNav,concernNav,meNav]
        
        self .setViewControllers(controllers, animated: true)
        
        self.tabBar.barStyle = UIBarStyle.Black
        self.tabBar.translucent = true
//        self.tabBar.barTintColor = UIColor.blackColor()
//        self.tabBar.backgroundImage = UIImage() //设置透明
        self.tabBar.tintColor = UIColor.msCommonColor()
        
    }
    
    func onTabBarItemButtonClicked(sender:UIButton){
        self.selectedIndex = sender.tag - kBarItemStartTag
        
        for var index = 0; index < 4; index++ {
            let tag = index + kBarItemStartTag
            let button = self.tabBarView?.viewWithTag(tag) as! UIButton
            button.selected = (button.tag == tag)
        }
        
        
    }
    
    
    func showLoginIfNeed(){
        
        if userMgr.hasShowLogin != true {
            
            let userOption = MsUserTypeOptionViewController()
            userOption.viewSource = UserOptionSource.FirstInstall
            let nav = UINavigationController(rootViewController: userOption)
            
            self.selectedViewController?.view.hidden = true
            self.selectedViewController!.presentViewController(nav, animated: false, completion: {
                self.selectedViewController?.view.hidden = false
            })
        }
    }
    
    
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
