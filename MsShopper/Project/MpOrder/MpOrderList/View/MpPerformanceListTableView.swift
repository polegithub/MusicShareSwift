//
//  MpPerformanceListTableView.swift
//  MusicShare
//
//  Created by poleness on 16/1/31.
//  Copyright © 2016年 poleness. All rights reserved.
//

import UIKit

protocol MpPerformanceTableViewDelegate{
    func refreshPerformanceData()
    func loadModePerformanceData()
    
}

class MpPerformanceListTableView: UIView,UITableViewDelegate,UITableViewDataSource,PullTableViewDelegate {
    let cellIdentifier = "MpPerformanceListTableViewCell"
    
    var delegate:MpPerformanceTableViewDelegate?
    
    //UI
    var tableView:PullTableView?

    //data
    var dataArray = NSArray()
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clearColor()
        self.initTableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initTableView(){
        self.tableView = PullTableView(frame: self.bounds, style: UITableViewStyle.Grouped)
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.pullDelegate = self
        self.tableView?.backgroundColor = UIColor.clearColor()
        
        self.tableView! .registerNib(UINib(nibName: "MpOrderListTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        
        self.tableView?.loadMoreView .setBackgroundColor(UIColor.msBackGroundColor(), textColor: UIColor.lightGrayColor(), arrowImage: nil, finishText: "没有更多了...")
        
        
        self .addSubview(self.tableView!)
        
        self.tableView!.reloadData()
    }
    
    //更新数据
    func updateData(array:NSArray){
        if self.tableView!.pullTableIsLoadingMore == true{
            self.tableView?.pullTableIsLoadingMore = false
        }
        
        if self.tableView!.pullTableIsRefreshing == true{
            self.tableView?.pullTableIsRefreshing = false
        }
        
        self.dataArray = array
        
        self.tableView!.reloadData()
    }
    
    ///
    /// UITableViewDataSource
    ///
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        //        return self.dataArray.count
        return 5
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 30
        }
        return 15
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! MpOrderListTableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        if indexPath.section < self.dataArray.count{
            let model = self.dataArray .objectAtIndex(indexPath.section) as! NormOrderModel
            
        }
        
        return cell
    }
    
    
    
    ///
    /// UITableViewDelegate
    ///
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return  120
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView .deselectRowAtIndexPath(indexPath, animated:true)
        
    }
    
    
    //load more
    func pullTableViewDidTriggerLoadMore(pullTableView: PullTableView!) {
        self.delegate? .refreshPerformanceData()
    }
    
    func pullTableViewDidTriggerRefresh(pullTableView: PullTableView!) {
        self.tableView?.isFinished = true
        self.delegate? .loadModePerformanceData()
    }
    
    
}
