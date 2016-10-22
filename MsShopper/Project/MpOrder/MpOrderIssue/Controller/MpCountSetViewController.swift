//
//  MpCountSetViewController.swift
//  MusicShare
//
//  Created by poleness on 16/1/7.
//  Copyright © 2016年 poleness. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol MpCountSetViewDelegate{
    func didSetCount(count:Int)
}


class MpCountSetViewController: MsBaseViewController {

    @IBOutlet weak var slide: UISlider!
    @IBOutlet weak var valueTxt: UITextField!
    
    var delegate:MpCountSetViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func initView(){
        let left = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("cancelView"))
        let right = UIBarButtonItem(title: "确认", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("saveAction"))
        self.navigationItem.leftBarButtonItem = left
        self.navigationItem.rightBarButtonItem = right
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        self .setNavigationTitle("设置人数")
        self.view.backgroundColor = UIColor.msBackGroundColor()
        self .setNavigationMusicianImage()
        
        self.edgesForExtendedLayout = UIRectEdge.None
        
        self.valueTxt.text = ""
        
        self.slide.maximumValue = 10
        self.slide.minimumValue = 1
        self.slide.continuous = true
        
        if self.valueTxt.text!.isEmpty {
            self.valueTxt.text = "1"
        }
        
        self.slide.thumbTintColor = UIColor.msCommonColor()
        self.slide.minimumTrackTintColor = UIColor.msCommonColor()
        
    }
    
    
    func cancelView(){
        if self.presentingViewController != nil{
        self.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
        }else{
            self .dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func saveAction(){
        if self.valueTxt.text!.isEmpty{
            SVProgressHUD .showInfoWithStatus("请输入您需要的人数")
            return
        }
        
        self.delegate? .didSetCount(Int(self.valueTxt.text!)!)
        
        self.cancelView()
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
    
    @IBAction func slideValueChanged(sender: AnyObject) {
        let value:Float = self.slide.value
        let roundValue = lroundf(value)
        
        self.valueTxt.text = NSString(format: "%d", roundValue) as String
        
    }
    
}
