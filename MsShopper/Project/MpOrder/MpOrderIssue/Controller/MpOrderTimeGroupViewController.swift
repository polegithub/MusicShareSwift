//
//  MpOrderTimeGroupViewController.swift
//  MusicShare
//
//  Created by poleness on 16/1/26.
//  Copyright © 2016年 poleness. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol MpOrderTimeGroupDelegate{
    func didFinishTimeGroupData(array:NSArray)
}

class MpOrderTimeGroupViewController: MsBaseViewController,UITableViewDelegate,UITableViewDataSource ,MpSetOrderTimeDelegate{
    
    let cellIdentifier = "MpOrderTimeGroupViewControllerCell"

    var delegate:MpOrderTimeGroupDelegate?
    
    var tableView:UITableView?
    var addBtn :UIButton?
    
    var dataArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView!.reloadData()
        self.setNavigationShopperImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initView(){
        
        self.initBarButtonView()
        
        self .setNavigationTitle("演出时间")
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        self.initTableView()
    }
    
    
    func initBarButtonView(){
        let left = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("cancelAction"))
        let right = UIBarButtonItem(title: "保存", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("saveAction"))
        
        self.navigationItem.leftBarButtonItem = left
        self.navigationItem.rightBarButtonItem = right
    }
    
    func initTableView(){
        self.addBtn = UIButton(frame: CGRectMake(cellLeftMargin,15,kScreenWidth - cellLeftMargin*2,88-20))
        self.addBtn!.addTarget(self, action: Selector("addNewTimeModel"), forControlEvents: UIControlEvents.TouchUpInside)
        self.addBtn?.layer.borderColor = UIColor.msCommonColor().CGColor
        self.addBtn?.layer.borderWidth = 1.0
        self.addBtn?.setTitle("添加时间段", forState: UIControlState.Normal)
        self.addBtn?.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        
        let bottomView = UIView(frame: CGRectMake(0,0,kScreenWidth,88))
        bottomView .addSubview(self.addBtn!)
        
        self.tableView = UITableView(frame: CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64), style: UITableViewStyle.Grouped)
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        self.tableView?.tableFooterView = bottomView
        self.tableView!.registerNib(UINib(nibName: "MpTimeGroupTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        self.view .addSubview(self.tableView!)
    }
    
    override func goBack() {
        self.dismiss()
    }
    
    func cancelAction(){
        self.dismiss()
    }
    
    func saveAction(){
        self.delegate? .didFinishTimeGroupData(self.dataArray)
        self .cancelAction()
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

        return self.dataArray.count
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return "删除"
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
        if editingStyle == UITableViewCellEditingStyle.Delete {
            if indexPath.section < self.dataArray.count{
            self.dataArray .removeObjectAtIndex(indexPath.section)
                self.tableView!.reloadData()
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! MpTimeGroupTableViewCell

        if indexPath.section < self.dataArray.count{
        let model = self.dataArray .objectAtIndex(indexPath.section) as! MpOrderTimeModel
        cell.timeStartLabel.text = model.timeStart.timeStrWithFormat()
            cell.timeEndLabel.text = model.timeEnd.timeStrWithFormat()
            cell.deadlineLabel.text = model.deadline.timeStrWithFormat()
            cell.priceLabel.text = "￥" + model.price
            
            if model.peopleCount > 1{
            cell.countLabel.text = String(model.peopleCount) + "人"
            }else{
                cell.countLabel.text = "单人"
            }
        }
        
        return cell
    }
    

    
    ///
    /// UITableViewDelegate
    ///
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return  155
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView .deselectRowAtIndexPath(indexPath, animated:true)        
        
        let subVC = MpSetOrderTimeViewController()
        subVC.delegate = self
        subVC.isModify = true
        if self.dataArray.count > indexPath.section {
            let model = self.dataArray .objectAtIndex(indexPath.section) as! MpOrderTimeModel
            subVC.timeModel = model
            self.enterTimeDetailView(subVC)
        }
    }
    
    /**
     * delegate
     */
     //MpSetOrderTimeDelegate
    func didFinishAddNewTimeModel(timeModel: MpOrderTimeModel){
        if self.dataArray.count > 3 {
            SVProgressHUD .showInfoWithStatus("最多只能设置3个时间段")
            return
        }
        for item in self.dataArray{
            let model = item as! MpOrderTimeModel
            if model .isEqual(timeModel){
                SVProgressHUD .showInfoWithStatus("请勿重复添加")
                return
            }
        }
        self.dataArray .addObject(timeModel)
        self.tableView!.reloadData()
    }
    
    func didFinishModifyTimeModel(){
        self.tableView!.reloadData()
    }
    
    
    /**
     Action
     */
    func addNewTimeModel(){
        if self.dataArray.count > 3 {
            SVProgressHUD .showInfoWithStatus("最多只能设置3个时间段")
            return
        }
        
        let subVC = MpSetOrderTimeViewController()
        subVC.delegate = self
        if self.dataArray.count > 0 {
            let model = self.dataArray .firstObject as! MpOrderTimeModel
            subVC.timeModel = model.copy() as! MpOrderTimeModel
        }
        subVC.isModify = false
        
        self.enterTimeDetailView(subVC)
    }
    
    
    func enterTimeDetailView(subVC:MpSetOrderTimeViewController ){

        self.hidePushViewController(subVC, animated: true)
    
    }
    

}
