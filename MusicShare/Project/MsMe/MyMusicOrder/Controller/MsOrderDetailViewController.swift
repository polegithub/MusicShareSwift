//
//  MsOrderDetailViewController.swift
//  MusicShare
//
//  Created by poleness on 16/1/8.
//  Copyright © 2016年 poleness. All rights reserved.
//

import UIKit
import SVProgressHUD

class MsOrderDetailViewController: MsBaseViewController,UITableViewDataSource,
UITableViewDelegate{
    
    
    var acceptBtn: UIButton!
    
    let shopSection = 0
    let infoSection = 1
    let timeSection = 2
    let locationSection = 3
    
    var type:Int = OrderBelong.PerOrder
    
    //data
    var dataSource = NSMutableArray()
    var timeArray = NSMutableArray()
    var orderInfo:NormOrderModel?
    
    var tableView: UITableView!
    
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
        self .setLeftBackImageWithWhite()
        self.view.backgroundColor = UIColor.msBackGroundColor()
        
        self.setNavigationTitle("订单详情")
        
        //接单
        self.initSubView()
        
        var bottomLayout:CGFloat = 0.0
        if type == OrderBelong.PubOrder{
            self.acceptBtn.hidden = false
            bottomLayout = 44.0
        }else{
            self.acceptBtn.hidden = true
            bottomLayout = 0.0
        }
        
        //tableview
        self.tableView = UITableView(frame: CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - bottomLayout), style :.Grouped)
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        self.tableView.backgroundColor = UIColor.clearColor()
        
        self.view .addSubview(self.tableView!)
        self.view .addSubview(self.acceptBtn)

    }
    
    func initSubView(){
        self.acceptBtn = UIButton(frame: CGRectMake(0,kScreenHeight - 44 - 64,kScreenWidth,44))
        self.acceptBtn .setTitle("接单", forState: UIControlState.Normal)
        self.acceptBtn .addTarget(self, action: Selector("acceptOrderAction:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.acceptBtn.backgroundColor = UIColor.msCommonColor()
        self.acceptBtn .setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
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
        return 4
        
    }
    
    //    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
    //        return 0.1
    //    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == shopSection {
            return 1
        }else if section == timeSection {
            return 3
        }else if section == infoSection{
            return 2
        }else{
            return 2
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "orderDetailTransporterInfoTel"
        
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        
        if (cell == nil) {
            
            cell = UITableViewCell(style:UITableViewCellStyle.Value1, reuseIdentifier:cellIdentifier)
        }
        
        cell!.textLabel!.font = UIFont.systemFontOfSize(15.0)
        cell!.detailTextLabel?.font = UIFont.systemFontOfSize(14.0)
        
        //        cell?.textLabel?.textColor = UIColor.whiteColor()
        //        cell?.detailTextLabel?.textColor = UIColor.whiteColor()
        
        cell?.textLabel?.text = ""
        cell?.imageView?.image = nil
        
        cell?.accessoryType = UITableViewCellAccessoryType.None
        
        let section = indexPath.section
        let row = indexPath.row
        
        if self.orderInfo == nil{
            return cell!
        }
        
        cell?.contentView .removeAllSubviews()
        
        if section == shopSection {
            cell?.textLabel?.text = self.orderInfo?.shopName
            
            let image = UIImageView(frame: CGRectMake(cellLeftMargin, 44/2-30/2, 30, 30))
            image.layer.cornerRadius  = 15
            image.clipsToBounds = true
            if self.orderInfo!.shopLogo.characters.count > 0{
                image.setImageWithURL(NSURL(string: self.orderInfo!.shopLogo)!, placeholderImage: UIImage(named: "icon.png"))
            }else{
                image.image = UIImage(named:"icon.png")
            }
            cell?.contentView .addSubview(image)
            
        }else if section == infoSection {
            if row == 0 {
                if self.orderInfo != nil{
                    cell?.textLabel!.text = self.orderInfo!.title
                }
            }else{
                if self.orderInfo != nil{
                    cell?.textLabel!.text = self.orderInfo!.orderDesc
                }
            }
            
        }else if section == timeSection {
            //时间
            if row == 0{
                let startStr = self.orderInfo?.timeStart .timeStrWithFormat("MM-dd HH:mm")
                let endStr = self.orderInfo?.timeEnd.timeStrWithFormat("MM-dd HH:mm")
                cell?.textLabel?.text = "演出时间"
                cell?.detailTextLabel?.text = startStr! + " ~ " + endStr!
            }else if row == 1{
                cell?.textLabel?.text =  "报名截止时间"
                cell?.detailTextLabel?.text = self.orderInfo!.deadline.timeStrWithFormat()
            }else{
                cell?.textLabel?.text = "已报名人数"
                cell?.detailTextLabel?.text = String(self.orderInfo!.signUpCount) + "人"
            }
            
        }else if section == locationSection{
            if row == 0 {
                let name:String  = (self.orderInfo?.address?.addressName)!
                if name.isEmpty{
                    cell?.textLabel?.text = "地址名称暂无"
                }else{
                    cell?.textLabel?.text = name
                }
            }else{
                if self.orderInfo!.address != nil{
                    cell?.textLabel!.text = self.orderInfo!.address!.addressFull
                }else{
                    cell?.textLabel?.text = "地址暂无"
                }
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
        let isLogin = userMgr.isLogin()
        //        let currentType = userMgr.userProperty
        
    }
    
    /**
     *  Action
     */
    func alertForComfirmAccept(){
        
        let alert = UIAlertController(title: "确认接单？", message: "接单后需经过发布人筛选才能最终确认订单", preferredStyle: UIAlertControllerStyle.Alert)
        
        let cancel = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        let confirm = UIAlertAction(title: "确认", style: UIAlertActionStyle.Default) { (action) -> Void in
            let button = UIButton()
            self.acceptOrderAction(button)
        }
        
        alert .addAction(cancel)
        alert.addAction(confirm)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    //接单
    func acceptOrderAction(sender: AnyObject) {
        SVProgressHUD .showInfoWithStatus("接单成功，请等待")
        
        self.navigationController!.popToRootViewControllerAnimated(false)
        
        NSNotificationCenter.defaultCenter() .postNotificationName(kNotificationEnterMyorder, object: nil)
        
    }
    
}
