//
//  MsOrderPayViewController.swift
//  MusicShare
//
//  Created by poleness on 15/12/6.
//  Copyright © 2015年 poleness. All rights reserved.
//

import UIKit

let payWechat = 0
let payZhifubao = 1

class MsOrderPayViewController: MsBaseViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var dataArray = NSMutableArray()
    var payType = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge.None
        
        self .setLeftBackImageWithWhite()
        self .setNavigationMusicianImage()
        self .setNavigationTitle("订单确认")
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        self.view.backgroundColor = UIColor.msBackGroundColor()
        
        self.initPayBtn()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initPayBtn(){
        let btn = UIButton(frame: CGRectMake(50, 222, kScreenWidth - 100, 44))
        btn.layer.cornerRadius = 4.0
        btn.backgroundColor = UIColor.msCommonColor()
        btn .setTitle("确认支付", forState: UIControlState.Normal)
        btn .setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        btn .addTarget(self, action: Selector("confirmPayAction:"), forControlEvents: UIControlEvents.TouchDown)
        btn.userInteractionEnabled = true
        
        self.tableView .addSubview(btn)
        
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
        let cellIdentifier = "MsOrderPayViewControllerCell"
        
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
            
            cell?.textLabel?.text = "订单金额"
            cell?.detailTextLabel?.text = "￥1.0"
            cell?.detailTextLabel?.textColor = UIColor.msCommonColor()
            
        }else if section == 1{
            if row == 0 {
                cell?.imageView?.image = UIImage(named: "wechat")
                cell?.textLabel?.text = "微信支付"
            }else if row == 1 {
                cell?.imageView?.image = UIImage(named: "zhifubao")
                cell?.textLabel?.text = "支付宝支付"
            }
            if self.payType == row {
                cell?.accessoryView = UIImageView(image: UIImage(named: "check"))
            }else{
                cell?.accessoryView = UIImageView(image: UIImage(named: "uncheck"))
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
        
        if indexPath.section == 1 {
            if self.payType == indexPath.row {
                return
            }
            self.payType = indexPath.row
            self.tableView .reloadData()
        }
 
    }

    
    func confirmPayAction(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
        
//        let alert = UIAlertController(title: "支付成功", message: "请到您的乐谱下面查看", preferredStyle: UIAlertControllerStyle.Alert)
//        let action = UIAlertAction(title: "好的", style: UIAlertActionStyle.Cancel, handler: nil)
//        alert .addAction(action)
//        self .presentViewController(alert, animated: true) { () -> Void in
//        }
    }
    
    
    
    //网络请求
    func requestFotData(){
        
        self.tableView?.reloadData()
        
    }


}
