//
//  MsBaseViewController.swift
//  MusicShare
//
//  Created by poleness on 15/12/1.
//  Copyright (c) 2014年 uni2uni. All rights reserved.
//

import UIKit
import Foundation
import SVProgressHUD


class MsBaseViewController: UIViewController ,UIGestureRecognizerDelegate,UINavigationControllerDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    /**
     设置导航栏默认背景图片
     */
    func setNavigationMusicianImage(){
        let image = UIImage(named: "temp_11")
        self.navigationController?.navigationBar.setBackgroundImage(image, forBarMetrics: UIBarMetrics.Default)
    }
    
    func setNavigationShopperImage(){
        let image = UIImage(named: "temp_8")
        self.navigationController?.navigationBar.setBackgroundImage(image, forBarMetrics: UIBarMetrics.Default)
        
    }
    
    /**
     设置导航栏的标题
     
     - parameter title: title description
     - parameter color: 默认白色
     */
    func setNavigationTitle(title:NSString,color:UIColor = UIColor.whiteColor()){
        let titleLabel = UILabel(frame: CGRectZero)
        titleLabel.text = title as String
        titleLabel.textColor = color
        titleLabel.font = UIFont.systemFontOfSize(17)
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel .sizeToFit()
        titleLabel.backgroundColor = UIColor.clearColor()
        titleLabel.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        
        self.navigationItem.titleView = titleLabel
    }
    
    
    /**
     设置导航栏透明
     */
    func setNavigationTransparent(transparent:Bool){
        if transparent == true{
            //first,must set default image
            self.setNavigationDefaultImage()
        }
        
        if self.navigationController == nil {
            return
        }
        
        for view in (self.navigationController?.navigationBar.subviews)!{
            if view .isKindOfClass(NSClassFromString("_UINavigationBarBackground")!){
                if transparent {
                    view.hidden = true
                }else{
                    view.alpha = 1.0;
                    view.hidden = false
                }
            }
        }
        
    }
    
    func setNavigationDefaultImage(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
    }
    
    /**
     设置nav 返回箭头
     */
    func setLeftBackImageWithWhite(){
        
        let left = UIBarButtonItem(image: UIImage(named: "left_arrow_white"), style: UIBarButtonItemStyle.Plain, target: self, action: "goBack")
        
        self.navigationItem.leftBarButtonItem = left
        
        let canWork = self.navigationController? .respondsToSelector(Selector("interactivePopGestureRecognizer"))
        if (canWork == true) {
            self.navigationController?.interactivePopGestureRecognizer?.enabled = true
            self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        }
        
        
    }
    
    /**
     返回 action
     */
    func goBack(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func dismiss(){
        if self.presentingViewController != nil{
            self.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
        }else{
            self .dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func hidePushViewController(viewController: UIViewController, animated: Bool){
        
        let canWork = self.navigationController? .respondsToSelector(Selector("interactivePopGestureRecognizer"))
        if (canWork == true) {
            self.navigationController?.interactivePopGestureRecognizer?.enabled = false
        }
        
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool){
        let canWork = self.navigationController? .respondsToSelector(Selector("interactivePopGestureRecognizer"))
        if (canWork == true) {
            self.navigationController?.interactivePopGestureRecognizer?.enabled = true
        }
    }
    
}
