//
//  MpNormalOrderListTableView.swift
//  MusicShare
//
//  Created by poleness on 16/1/31.
//  Copyright © 2016年 poleness. All rights reserved.
//

import UIKit

protocol MpNormalOrderListViewDelegate{
    func refreshNormalOrderList(state:Int, isLoadMore:Bool)
    func didSelectNormalOrder(order:NormOrderModel)
    
}

class MpNormalOrderListTableView: UIView,UITableViewDelegate,UITableViewDataSource,PullTableViewDelegate,MsTopBarViewDelegate {
    let cellIdentifier = "MpNormalOrderListTableViewCell"
    
    var delegate:MpNormalOrderListViewDelegate?
    
    //UI
    var tableView:PullTableView?
    var topBar:MsTopBarView?
    
    //data
    var dataArray = NSArray()
    var currentState:Int = 0
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame = frame
        self.initSubView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSubView(){
        /*
        全部，0
        待发布 1
        进行中 2
        待评价 3
        已结束 4
        */
        let titleArray = ["全部","待发布","进行中","待评价","已结束"]
        self.topBar = MsTopBarView(titleArray: titleArray)
        self.topBar?.delegate = self
        self .addSubview(self.topBar!)
        
        let height =  self.topBar!.height()
        self.tableView = PullTableView(frame:CGRectMake(0,height,kScreenWidth,self.height() - height ), style: UITableViewStyle.Grouped)
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
    func updateData(model:MpRefreshOrderModel,isFinished:Bool){
        
        self.tableView?.isFinished = isFinished
        
        if self.tableView!.pullTableIsLoadingMore == true{
            self.tableView?.pullTableIsLoadingMore = false
        }
    
        
        if self.tableView!.pullTableIsRefreshing == true{
            self.tableView?.pullTableIsRefreshing = false
        }
        
        self.dataArray = model.dataArray
        
        self.tableView!.reloadData()
    }
    
    //style view
    func orderStyleView(styleNameArray:NSArray)->UIView{
        let widthTotal = kScreenWidth - 130 - 30
        let view = UIView(frame: CGRectMake(0,0,widthTotal,20))
        var currentPos:CGFloat = 0
        
        for item in styleNameArray{
            let model = item as! MpStyleModel
            let width = model.styleName.textSize(15).width + 10
            
            if (width + currentPos + 10) <= widthTotal{
                if currentPos > 0{
                    currentPos = currentPos + width + 10
                }else{
                    currentPos = 1
                }
                let label = UILabel(frame: CGRectMake(currentPos,0,width,20))
                label.text = model.styleName
                label.textAlignment = NSTextAlignment.Center
                label.textColor = UIColor.whiteColor()
                label.backgroundColor = UIColor.msCommonColor()
                label.font = UIFont.systemFontOfSize(15)
                view .addSubview(label)
            }
        }
        
        return view
    }
    
    
    ///
    /// UITableViewDataSource
    ///
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.dataArray.count
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
            cell.orderTitle.text = model.title
            cell.orderFee.text = "￥" + model.price
            
            cell.orderState.text = model.stateDesc
            
            if model.timeStart.isEmpty || model.timeEnd.isEmpty{
                cell.timePeriod.text = ""
            }else{
                
                cell.timePeriod.text = model.timeStart.timeStrWithFormat("MM-dd hh:mm") + " ~ " + model.timeEnd.timeStrWithFormat("MM-dd hh:mm")
            }
            
            //url
            let img = UIImage(named: "temp_10")
            if model.shopLogo.characters.count > 0 {
                cell.logoImage.setImageWithURL(NSURL(string: model.shopLogo)!, placeholderImage: img)
            }else{
                cell.logoImage.image = img
            }
            
            //name
            cell.shopName.text = model.address?.addressName
            
            //tag
            cell.tagView.hidden = model.styleArray.count > 0 ? false:true
            cell.tagView .removeAllSubviews()
            cell.tagView .addSubview(self.orderStyleView(model.styleArray))
        }
        
        return cell
    }
    
    
    ///
    /// UITableViewDelegate
    ///
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if self.dataArray.count > indexPath.section{
            let model = self.dataArray .objectAtIndex(indexPath.section) as! NormOrderModel
            if model.styleArray.count == 0{
                return 100
            }
        }
        return  120
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView .deselectRowAtIndexPath(indexPath, animated:true)
        
        let model = self.dataArray .objectAtIndex(indexPath.section)
        self.delegate?.didSelectNormalOrder(model as! NormOrderModel)
        
    }
    
    //topbardeledate
    func didSelectedTopbar(index:Int){
        self.currentState = index
        self.delegate?.refreshNormalOrderList(index,isLoadMore: false)
    }
    
    
    //load more
    func pullTableViewDidTriggerLoadMore(pullTableView: PullTableView!) {
        self.delegate?.refreshNormalOrderList(self.currentState,isLoadMore: true)
    }
    
    func pullTableViewDidTriggerRefresh(pullTableView: PullTableView!) {
        self.delegate?.refreshNormalOrderList(self.currentState,isLoadMore: false)

    }
    
    
}
