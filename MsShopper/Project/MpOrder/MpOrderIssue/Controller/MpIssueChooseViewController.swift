//
//  MpIssueChooseViewController.swift
//  MusicShare
//
//  Created by poleness on 16/1/28.
//  Copyright © 2016年 poleness. All rights reserved.
//

import UIKit

class MpIssueChooseViewController: MsBaseViewController {
    
    
    //scrollView
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    
    @IBOutlet weak var nomalOrderBtn: UIButton!
    @IBOutlet weak var residentBtn: UIButton!
    @IBOutlet weak var showBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        
        self.addNotification()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.initNavView()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationTransparent(false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.scrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight + 64)
    }
    
    
    func initView(){
        
        self.view.backgroundColor = UIColor.clearColor()
        let blur = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = UIScreen.mainScreen().bounds
        self.view .insertSubview(blurView, belowSubview: self.scrollView)
        
        self.scrollView.backgroundColor = UIColor.clearColor()
        
        self.setButtonBorder(self.nomalOrderBtn)
        self.setButtonBorder(self.residentBtn)
        self.setButtonBorder(self.showBtn)
        
        
        let left = UIBarButtonItem(image: UIImage(named: "down_arrow_white"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("dismissView"))
        self.navigationItem.leftBarButtonItem = left
    }
    
    func initNavView(){
        self .setNavigationTransparent(true)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }
    
    func setButtonBorder(button:UIButton){
        button.layer.borderColor = UIColor.whiteColor().CGColor
        button.layer.borderWidth = 1.0
        button.backgroundColor = UIColor.clearColor()
    }
    
    
    func addNotification(){
        NSNotificationCenter .defaultCenter() .addObserver(self, selector: Selector("issueNewOrderFinish"), name: kNotificationIssueNewOrder, object: nil)
    }
    
    func issueNewOrderFinish(){
        self.dismissView()
    }
    
    func dismissView(){
        self.dismiss()
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
    *  Action
    */
    
    //发布
    @IBAction func issueOrderAction(sender: AnyObject) {
        
        let button = sender as! UIButton
        let tag = button.tag
        
        var subVC = UIViewController()
        if tag == OrderType.normal {
            subVC = MpCreateNormalOrderViewController()
        }else if tag == OrderType.resident {
            subVC = MpCreateResidentOrderViewController()
        }else if tag == OrderType.show{
            subVC = MpCreatePerformViewController()
        }
        self.hidePushViewController(subVC, animated: true)
    }
    
}
