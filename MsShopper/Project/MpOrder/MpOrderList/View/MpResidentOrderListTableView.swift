//
//  MpResidentOrderListTableView.swift
//  MusicShare
//
//  Created by poleness on 16/2/15.
//  Copyright © 2016年 poleness. All rights reserved.
//

import UIKit

protocol MpResidentOrderListViewDelegate{
    func refreshResidentOrderList()
    func loadModeResidentOrderList()
}

class MpResidentOrderListTableView: UIView,UITableViewDelegate,UITableViewDataSource,PullTableViewDelegate ,MsTopBarViewDelegate{

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    let cellIdentifier = "MpResidentOrderListTableViewCell"
    
    var delegate:MpResidentOrderListViewDelegate?
    
    //UI
    var tableView:PullTableView?
    var topBar:MsTopBarView?

    
    //data
    var dataArray = NSArray()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame = frame
        self.initSubView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSubView(){
        
        let titleArray = ["全部","已报名","已完成"]
        self.topBar = MsTopBarView(titleArray: titleArray)
        self.topBar?.delegate = self
        self .addSubview(self.topBar!)
        
        let height =  self.topBar!.height()
        self.tableView = PullTableView(frame:CGRectMake(0,height,kScreenWidth,kScreenHeight - height), style: UITableViewStyle.Grouped)
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.pullDelegate = self
        
        self.tableView! .registerNib(UINib(nibName: "MpOrderListTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.tableView!.backgroundColor = UIColor.clearColor()
        
        
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
        if section == 0{
            return 30
        }
        return 15
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! MpOrderListTableViewCell
        
        
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
    
    //topbar
    func didSelectedTopbar(index:Int){
        
    }

    
    //load more
    func pullTableViewDidTriggerLoadMore(pullTableView: PullTableView!) {
        
        self.delegate? .loadModeResidentOrderList()
    }
    
    func pullTableViewDidTriggerRefresh(pullTableView: PullTableView!) {
        self.tableView?.isFinished = true
        self.delegate? .refreshResidentOrderList()
    }
    


}
