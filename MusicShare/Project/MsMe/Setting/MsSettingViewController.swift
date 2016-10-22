//
//  MsSettingViewController.swift
//  MusicShare
//
//  Created by poleness on 15/12/13.
//  Copyright © 2015年 poleness. All rights reserved.
//


import UIKit
import SVProgressHUD

class MsSettingViewController: MsBaseViewController,UITableViewDataSource,UITableViewDelegate {
    
    var tableView: UITableView!
    var logoutBtn:UIButton?
    
    var dataArray = NSMutableArray()
    var payType = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge.None
        
        self .setLeftBackImageWithWhite()
        self .setNavigationMusicianImage()
        self .setNavigationTitle("设置")
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        self.view.backgroundColor = UIColor.msBackGroundColor()
        
        self.tableView = UITableView(frame: CGRectMake(0, 0, kScreenWidth, kScreenHeight), style :.Grouped)
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        self.view .addSubview(self.tableView!)
        
        self.initLogoutBtn()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initLogoutBtn(){
       self.logoutBtn = UIButton(frame: CGRectMake(50, 222, kScreenWidth - 100, 44))
        self.logoutBtn!.layer.cornerRadius = 4.0
        self.logoutBtn!.backgroundColor = UIColor.msCommonColor()
        self.logoutBtn! .setTitle("退出", forState: UIControlState.Normal)
        self.logoutBtn! .setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.logoutBtn! .addTarget(self, action: Selector("logoutAction:"), forControlEvents: UIControlEvents.TouchDown)
        self.logoutBtn!.userInteractionEnabled = true
        self.tableView .addSubview(logoutBtn!)

    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    // MARK:tableviewdelegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }else {
            return 2
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "MsSettingViewControllerCell"
        
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        
        if (cell == nil) {
            cell = UITableViewCell(style:UITableViewCellStyle.Value1, reuseIdentifier:cellIdentifier)
        }
        
        //        cell?.delegate = self
        cell!.backgroundColor = UIColor .whiteColor()
        
        let section = indexPath.section
        let row = indexPath.row
        
        cell?.contentView .removeAllSubviews()
        cell?.imageView?.image = nil
        
        cell?.textLabel?.numberOfLines = 0
        cell?.textLabel?.font = UIFont.systemFontOfSize(15.0)
        
        if section == 0{
            
            cell?.textLabel?.text = "设置1"
            cell?.detailTextLabel?.textColor = UIColor.msCommonColor()
            
        }else if section == 1{
            if row == 0 {
                cell?.textLabel?.text = "设置2"
            }else if row == 1 {
                cell?.textLabel?.text = "设置3"
            }

        }
        
        
        return cell!
    }
    
    ///
    /// UITableViewDelegate
    ///
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return  44
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView .deselectRowAtIndexPath(indexPath, animated:true )
        
    }
    
    
    func logoutAction(sender: AnyObject) {
        userMgr.userLogout()
        SVProgressHUD .showInfoWithStatus("退出成功")
        
        self.navigationController?.popToRootViewControllerAnimated(true)
        
    }
    
    

}
