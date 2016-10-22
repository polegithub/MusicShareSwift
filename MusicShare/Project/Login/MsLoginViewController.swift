//
//  MsLoginViewController.swift
//  MusicShare
//
//  Created by poleness on 15/12/12.
//  Copyright © 2015年 poleness. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD


enum UserLoginSource:Int {
    case FromOption = 0    //从选项进入
    case FromMine = 1      //从我的进入
}

class MsLoginViewController: MsBaseViewController,UIScrollViewDelegate,MsUserOptionDelegate{
    
    //
    var viewSource:UserLoginSource?
//    var currentType:MsuserType? //optoin页面用户选择的type
    
    //scrolView
    @IBOutlet weak var scrollView: UIScrollView!
    
    //imageView
    @IBOutlet weak var topImg: UIImageView!
    @IBOutlet weak var topImgHeightLayout: NSLayoutConstraint!
    
    //login button
    @IBOutlet weak var loginBtn: UIButton!
    
    //input view
    @IBOutlet weak var phoneTxt: UITextField!
    @IBOutlet weak var captchaTxt: UITextField!
    
    @IBOutlet weak var inputTopLayout: NSLayoutConstraint!
    
    //get captcha button
    @IBOutlet weak var getCaptchaBtn: UIButton!
    
    //注册说明
    @IBOutlet weak var regInfoLabel: UILabel!
    
    
    //定时器
    var timer:NSTimer?
    var timeLeft:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
        self.addNotification()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.phoneTxt .resignFirstResponder()
        self.captchaTxt.resignFirstResponder()
        
        NSNotificationCenter.defaultCenter() .removeObserver(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setNavigationTransparent(true)
        self.updateUserBaseInfo()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.scrollView?.contentSize = CGSizeMake(kScreenWidth, kScreenHeight+64)
    }
    
    func goBackToRoot() {
        
        //照顾商家
        self.navigationController!.popToRootViewControllerAnimated(true)
        
//        if self.viewSource == UserLoginSource.FromOption {
//            //选项
//            if self.navigationController != nil {
//                for view:UIViewController in (self.navigationController?.viewControllers)!{
//                    if view .isKindOfClass(MsUserTypeOptionViewController){
//                        self.dismissCurrentView(view)
//                    }
//                }
//            }
//        }else {
//            //普通进入
//            self.navigationController!.popToRootViewControllerAnimated(true)
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initView(){
        self .setNavigationTitle("登录")
        self .setLeftBackImageWithWhite()
        self.view.backgroundColor = UIColor.msBackGroundColor()
        
        self.topImg.contentMode = UIViewContentMode.ScaleAspectFill
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        self.getCaptchaBtn?.backgroundColor = UIColor.msCommonColor()
        self.getCaptchaBtn? .setTitle("验证码", forState: UIControlState.Normal)
        self.getCaptchaBtn?.layer.cornerRadius = 3.0
        
        self.loginBtn?.backgroundColor = UIColor.msCommonColor()
        self.loginBtn?.layer.cornerRadius = 4.0
        
        self.regInfoLabel.numberOfLines = 0
        
        if Device.IS_IPHONE_4 {
            //iphone4 特殊处理
            self.inputTopLayout.constant = 84.0
            self.topImgHeightLayout.constant = 84 + 64
        }
        
    }
    
    func addNotification(){
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("textChanged"), name: UITextFieldTextDidChangeNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyBoardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        
    }
    
    func updateUserBaseInfo(){
        
//        var rightTitle:String = ""
//        if currentType == MsuserType.Musician {
//            self.regInfoLabel.text = "未注册的手机号验证成功后将自动注册为乐享用户\n您选择的是音乐人，音乐人用户在登录后需要通过身份认证"
//            rightTitle = "我不是音乐人?"
//        }else if currentType == MsuserType.Shopper {
//            self.regInfoLabel.text = "未注册的手机号验证成功后将自动注册为乐享用户\n您选择的是乐享商家，商家用户在登录后需要上传资质审核，审核通过才能正常使用"
//            rightTitle = "我不是商家?"
//        }else{
//            self.regInfoLabel.text = "未注册的手机号验证成功后将自动注册为乐享用户"
//            rightTitle = "我是音乐人?"
//        }
//        
//        let right = UIBarButtonItem(title: rightTitle, style: UIBarButtonItemStyle.Plain, target: self, action: Selector("changeUserTypeAction"))
//        self.navigationItem.rightBarButtonItem = right
    }
    
    
    /**
     *  UNIT
     */
    
    func startTimerIfNeed(){
        if self.timer == nil {
            self.timer = NSTimer .scheduledTimerWithTimeInterval(1, target: self, selector: Selector("refreshCaptchaBtn"), userInfo: nil, repeats: true)
        }
        self.timer!.fire()
    }
    
    /**
     * UI
     */
    func refreshCaptchaBtn(){
        var title = "验证码"
        if self.timeLeft > 0 {
            self.timeLeft -= 1
            title = NSString(format: "%d秒", self.timeLeft) as String
        }else{
            if self.timer != nil{
                self.timer! .invalidate()
                self.timer = nil
            }
        }
        
        self.getCaptchaBtn.titleLabel?.text = title as String!
        self.getCaptchaBtn .setTitle(title as String, forState: UIControlState.Normal)
    }
    
    /**
     * Animation
     */
     
     //scrolview delegate
    func  scrollViewDidScroll(scrollView: UIScrollView) {
        
        var rate = scrollView.contentOffset.y / kScreenHeight
        rate = rate>0.15 ? 0.15 :rate
        self.topImg.transform = CGAffineTransformMakeScale(1-rate,1-rate)
    }
    /**
     *  Action
     */
     
     //输入内容检测-11位自动换行
    func textChanged(){
        if self.phoneTxt .isFirstResponder() {
            if self.phoneTxt.text?.characters.count == 11 {
                self.captchaTxt.becomeFirstResponder()
            }
        }
        
    }
    
    //键盘监控
    func keyBoardWillShow(notification:NSNotification){
        if (Device.IS_IPHONE_6 || Device.IS_IPHONE_6P) {
            return;
        }
        
        let userInfo = notification.userInfo! as Dictionary
        let aValue = userInfo[UIKeyboardFrameEndUserInfoKey]
        let keyY:CGFloat = ((aValue?.CGRectValue.origin.y)! as CGFloat)
        
        let offsetY:CGFloat =  keyY - (kScreenHeight - 294 - 44 )
        self.scrollView.contentOffset = CGPointMake(0, offsetY)
    }
    
    
    
    
    //获取验证码
    @IBAction func loginAction(sender: AnyObject) {
        
        //只有登录成功后才会修改userMgr.userProperty的值，其他场景都不修改
        if ((self.phoneTxt.text?.isEmpty) != false) {
            SVProgressHUD .showInfoWithStatus("请输入手机号")
            return
        }
        
        if (self.captchaTxt.text?.isEmpty) != false{
            SVProgressHUD .showInfoWithStatus("请输入验证码")
            return
        }
        
        //        //chenglong
        //        let token = "token"
        //        userMgr.updateUserTokenInfo("123", userToken: token)
        //
        //        self.goBackToRoot()
        //        return
        
//        var typeInt:Int
//        if self.currentType != nil{
//            typeInt = (self.currentType!.rawValue)
//        }else{
//            SVProgressHUD .showInfoWithStatus("还未选择用户类型")
//            return
//        }
        
//        let typeStr = NSString(format: "%d",typeInt) as String
        
        SVProgressHUD .showWithStatus("正在登录...")
        
        let request = MsRequestModel.requestForLogin(self.phoneTxt.text! as String, captcha: self.captchaTxt.text! as String, userType: "1")
        netWorkMgr.post(request) { (status, result) -> Void in
            
            if status == "ok" {
                SVProgressHUD .dismiss()
                
                let content:NSDictionary = (result!["payload"] as? NSDictionary)!
                if content.count > 0 {
                    //解析数据
                    self.parseUserInfo(content)
                    self.goBackToRoot()
                }
            }else{
                
            }
            
            
        }
    }
    
    func parseUserInfo(userInfo:NSDictionary){
        
        let accountInfo = userInfo .objectForKey("account") as! NSDictionary
        let userModel = MsUserModel(userInfo: accountInfo)
        let token = userInfo.stringWithKey("session")
        
        userMgr.updateUserTokenInfo(userModel.userId, userToken: token)
        userMgr.updateUserInfo(userModel)
    }
    
    //退出
    func dismissCurrentView(view:UIViewController){
        if view.presentingViewController != nil {
            view.presentingViewController! .dismissViewControllerAnimated(true, completion: {})
        }else{
            view .dismissViewControllerAnimated(true, completion: {})
        }
    }
    
    
    //切换用户类型
    func changeUserTypeAction(){
        
        if self.viewSource == UserLoginSource.FromOption {
            self.navigationController!.popViewControllerAnimated(true)
        }else {
            let subVC = MsUserTypeOptionViewController()
            subVC.viewSource = UserOptionSource.FromLogin
            subVC.delegate = self
            let nav = UINavigationController(rootViewController: subVC)
            self.presentViewController(nav, animated: true, completion: {})
        }
    }
    
    //切换用户的delegate
    func didselectUserOption(property: MsuserType) {
//        self.currentType = property
    }
    
    
    
    @IBAction func getCaptchaAction(sender: AnyObject) {
        let text = self.phoneTxt.text
        if text?.characters.count == 0 {
            
            return
        }
        
        let request = MsRequestModel.requestForGetLoginCaptcha(self.phoneTxt.text! as String)
        netWorkMgr.post(request) { (status, result) -> Void in
            if status == "ok"{
                if result != nil {
                    let status = result!["status"] as? String
                    if status == "ok" {
                        let content:NSDictionary = (result!["payload"] as? NSDictionary)!
                        if content.count > 0 {
                            self.timeLeft = Int(content.stringWithKey("cooldown"))!
                            let  typeSms:Int = Int(content.stringWithKey("type"))! //1为短信验证码，2为语音验证码
                            if typeSms == 2 {
                                SVProgressHUD .showInfoWithStatus("您将收到语音验证码，请注意接听")
                            }
                            self.startTimerIfNeed()
                        }else{
                            SVProgressHUD .showInfoWithStatus("验证码获取失败啦，请重新试下？")
                        }
                    }
                }
            }        }
    }
    
    
}