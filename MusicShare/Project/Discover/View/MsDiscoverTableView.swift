//
//  MsDiscoverTableView.swift
//  MusicShare
//
//  Created by poleness on 16/1/5.
//  Copyright © 2016年 poleness. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol MsDiscoverTableViewDelegate{
    func refreshDiscoverData(type:Int)
    func didSelectDiscoverOrderDetail(order:NormOrderModel)
    func userClickAcceptAction(orderModel:NormOrderModel)
}

class MsDiscoverTableView: UIView,UITableViewDelegate,UITableViewDataSource,PullTableViewDelegate {
    
    var delegate:MsDiscoverTableViewDelegate?
    
    let orderSection = 1
    
    var userType:MsuserType?
    
    var menuArray = NSArray()
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
    //UI
    var tableView: PullTableView?
    
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        //        self.frame = frame
        self .initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        //        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
    
    func initView(){
        self.tableView = PullTableView(frame: self.bounds, style :.Grouped)
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        self.tableView?.pullDelegate = self
        self.tableView?.backgroundColor = UIColor.msBackGroundColor()
        self.tableView?.tableFooterView = UIView()
        
        self .addSubview(self.tableView!)
    }
    
    
    //更新数据
    func updateDisData(menuData:NSArray){
        self.tableView?.pullTableIsLoadingMore = false
        self.tableView?.pullTableIsRefreshing = false
        
        self.menuArray = NSArray(array: menuData)
        
        self.tableView!.reloadData()
    }
    
    
    //UI- BASE UNIT
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
    
    
    // MARK:tableviewdelegate
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 30.0
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1;
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return self.menuArray.count;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifierOrder = "MSDisCoverOrderCell"
        let cellIdentifierShow = "MSDisCoverShowCell"
        
        var cellOrder:MsTakeOrderTableViewCell?
        var cellShow:UITableViewCell?
        
        cellOrder = tableView.dequeueReusableCellWithIdentifier(cellIdentifierOrder) as? MsTakeOrderTableViewCell
        if cellOrder == nil{
            tableView .registerNib(UINib(nibName: "MsTakeOrderTableViewCell", bundle: nil),forCellReuseIdentifier: cellIdentifierOrder)
            
            cellOrder = tableView.dequeueReusableCellWithIdentifier(cellIdentifierOrder) as? MsTakeOrderTableViewCell
        }
        
  
        
        var section = indexPath.section
        let row = indexPath.row
        
        cellShow?.textLabel?.text = ""
        cellShow?.detailTextLabel?.text = ""
        cellShow?.imageView?.image = UIImage()
        
        cellShow?.contentView .removeAllSubviews()
        
        cellOrder?.selectionStyle = UITableViewCellSelectionStyle.Default
        
        if section < self.menuArray.count{
            let model:NormOrderModel = self.menuArray .objectAtIndex(section) as! NormOrderModel
            cellOrder?.acceptBtn .addTarget(self, action: Selector("userWantAcceptOrder:"), forControlEvents: UIControlEvents.TouchUpInside)
            cellOrder?.acceptBtn.tag = indexPath.row
            
            let defaultImg = UIImage(named: "temp_2")
            if model.shopLogo.characters.count > 0{
                cellOrder?.shopImage .setImageWithURL(NSURL(string: model.shopLogo)!, placeholderImage: defaultImg)
            }else{
                cellOrder?.shopImage.image = defaultImg
            }
            
            cellOrder?.shopName.text = model.address?.addressName
            cellOrder?.orderTitle.text = model.title
            
            if model.timeStart.isEmpty || model.timeEnd.isEmpty{
                cellOrder?.orderTime.text = ""
            }else{
                
                cellOrder?.orderTime.text = model.timeStart.timeStrWithFormat("MM-dd hh:mm") + " ~ " + model.timeEnd.timeStrWithFormat("MM-dd hh:mm")
            }
            
            //location
            cellOrder?.location.text = model.address?.addressFull
            
            //people count
            if model.peopleNeed <= 0 {
                //容错处理，至少1人
                model.peopleNeed = 1
            }
            
            cellOrder?.peopleCount.text = NSString(format: "人数：%d人", model.peopleNeed) as String
            
            
            //tag
            cellOrder?.styleView.hidden = model.styleArray.count > 0 ? false:true
            cellOrder?.styleView .removeAllSubviews()
            cellOrder?.styleView .addSubview(self.orderStyleView(model.styleArray))
            
            cellOrder?.price.text = "￥" + model.price
        }
        
        return cellOrder!
        
        //        if indexPath.section < 5  {
        //            return cellOrder!
        //        }else{
        //            return cellShow!
        //        }
    }
    
    ///
    /// UITableViewDelegate
    ///
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let section = indexPath.section
        if section < self.menuArray.count{
            let model:NormOrderModel = self.menuArray .objectAtIndex(section) as! NormOrderModel
            if model.styleArray.count == 0{
                return 190
            }
        }
        return 210
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView .deselectRowAtIndexPath(indexPath, animated:true )
        
        let model:NormOrderModel = self.menuArray .objectAtIndex(indexPath.section) as! NormOrderModel
        self.delegate? .didSelectDiscoverOrderDetail(model)
    }
    
    //pulltableviewdelegate
    func pullTableViewDidTriggerLoadMore(pullTableView: PullTableView!) {
        self.delegate?.refreshDiscoverData(refreshType.loadMore)
    }
    
    func pullTableViewDidTriggerRefresh(pullTableView: PullTableView!) {
        
        self.delegate?.refreshDiscoverData(refreshType.refresh)
    }
    
    
    /**
     *  Action
     */
    func userWantAcceptOrder(button:UIButton){
        
        let index = button.tag
        if index < self.menuArray.count{
            let model:NormOrderModel = self.menuArray .objectAtIndex(index) as! NormOrderModel
            self.delegate?.userClickAcceptAction(model)
        }else{
            SVProgressHUD .showInfoWithStatus("订单打瞌睡了，请刷新重试")
        }
    }
    
}
