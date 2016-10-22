//
//  MsMyNormalOrderListView.swift
//  MusicShare
//
//  Created by poleness on 16/2/1.
//  Copyright © 2016年 poleness. All rights reserved.
//

import UIKit


protocol MsMyNormalOrderListDelegate{
    func refreshNormalOrderList(state:Int, isLoadMore:Bool)
    func didSelectNormalOrder(order:NormOrderModel)
    
}

class MsMyNormalOrderListView: UIView,UITableViewDataSource,UITableViewDelegate,MsTopBarViewDelegate{
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
    lazy var defaultView:UIView = self.initDefaultView()
    
    var delegate :MsMyNormalOrderListDelegate?
    
    var dataArray = NSArray()
    
    var page = 0
    var totalPage = 0
    
    let cellIdentifier = "MsMyResidentStateListViewCell"
    
    //UI
    var tableView: UITableView?
    var topBar:MsTopBarView?
    
    
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
        
        let titleArray = ["全部","已报名","待演出","待评价","已结束"]
        self.topBar = MsTopBarView(titleArray: titleArray)
        self.topBar?.delegate = self
        self .addSubview(self.topBar!)
        
        self.tableView = UITableView(frame: CGRectMake(0, self.topBar!.height(), kScreenWidth, kScreenHeight - self.topBar!.height() - 64), style :.Grouped)
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        self.tableView?.backgroundColor = UIColor.msBackGroundColor()
        
        self.tableView? .registerNib(UINib(nibName: "MsOrderListTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        self.tableView?.tableFooterView = UIView()
        
        self .addSubview(self.tableView!)
    }
    
    
    func updateData(data:NSArray){
        self.dataArray = data
        
        if data.count > 0 {
            self.tableView?.tableHeaderView?.hidden = false
            
            if self.defaultView.superview != nil{
                self.defaultView.removeFromSuperview()
            }
            
        }else{
            self.tableView?.tableHeaderView?.hidden = true
            self.tableView!.addSubview(self.defaultView)
        }
        
        self.tableView!.reloadData()
        
    }
    
    
    /**
     *topbar
     */
    func didSelectedTopbar(index:Int){
        self.delegate?.refreshNormalOrderList(index, isLoadMore: false)
    }
    
    
    //tableview base model
    func leftTitleForOrder(state:Int)->String{
        var title = ""
        /*
        //音乐人查看订单状态
        let STATE_ALL = 0   //全部
        let STATE_SIGN = 1//已报名
        let STATE_ING = 2   //进行中
        let STATE_EVA = 3   //待评价
        let STATE_END = 4   //已结束（包括结束和取消）
        */
        switch (state){
        case  MS_STATE_ALL:
            break
        case MS_STATE_SIGN:
            break
        case MS_STATE_ING:
            break
        case MS_STATE_EVA:
            title = ""
            break
        case MS_STATE_END:
            break
        default :
            break
        }
        return title
    }
    
    func rightTitleForOrder(state:Int)->String{
        var title = ""
        /*
        //音乐人查看订单状态
        let STATE_ALL = 0   //全部
        let STATE_SIGN = 1//已报名
        let STATE_ING = 2   //进行中
        let STATE_EVA = 3   //待评价
        let STATE_END = 4   //已结束（包括结束和取消）
        */
        switch (state){
        case MS_STATE_ALL:
            break
        case MS_STATE_SIGN:
            break
        case MS_STATE_ING:
            break
        case MS_STATE_EVA:
            title = ""
            break
        case MS_STATE_END:
            break
        default:
            break
        }
        return title
    }
    
    /**
     UITableViewDelegate
     
     */
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0.0
        }
        return 30
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.dataArray.count
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! MsOrderListTableViewCell
        
        cell.backgroundColor = UIColor .whiteColor()
        cell.selectionStyle = UITableViewCellSelectionStyle.Blue
        
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
            
            //bottom button
            //            if 根据状态判断 bottom hidden 和height
        }
        
        
        return cell
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
    /// UITableViewDelegate
    ///
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if self.dataArray.count > indexPath.section{
            let model = self.dataArray .objectAtIndex(indexPath.section) as! NormOrderModel
            if model.styleArray.count == 0{
                return 136
            }
        }
        return  156
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView .deselectRowAtIndexPath(indexPath, animated:true )
        if self.dataArray.count > indexPath.section{
            let model = self.dataArray .objectAtIndex(indexPath.section) as! NormOrderModel
            self.delegate? .didSelectNormalOrder(model)
            
        }
    }
    
    
    //默认视图
    func initDefaultView() -> UIView{
        let view = UIView(frame: self.bounds)
        
        let label = UILabel(frame: CGRectMake(15,40,self.width() - 30,40))
        label.font = UIFont .msCellFont()
        label.text = "暂无订单\n"
        label.numberOfLines = 0
        label.textColor = UIColor.lightGrayColor()
        label.textAlignment = NSTextAlignment.Center
        
        view.addSubview(label)
        
        return view
    }
    
    
    
}
