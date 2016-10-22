//
//  MsAllPerformOrderListView.swift
//  MusicShare
//
//  Created by poleness on 15/12/28.
//  Copyright © 2015年 poleness. All rights reserved.
//

import UIKit


protocol MsMyResidentStateListDelegate{
    func didSelectAllResidentOrder()
    func didSelectResidentOrder(order:NormOrderModel)
}

class MsMyResidentStateListView: UIView ,UITableViewDataSource,UITableViewDelegate,MsTopBarViewDelegate{
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
    lazy var defaultView:UIView = self.initDefaultView()
    
    var delegate :MsMyResidentStateListDelegate?
    
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
        
        let titleArray = ["全部","已报名","已完成"]
        self.topBar = MsTopBarView(titleArray: titleArray)
        self.topBar?.delegate = self
        self .addSubview(self.topBar!)
        
        self.tableView = UITableView(frame: CGRectMake(0, self.topBar!.height(), kScreenWidth, kScreenHeight - self.topBar!.height()), style :.Grouped)
        
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        self.tableView?.backgroundColor = UIColor.msBackGroundColor()
        
        self.tableView? .registerNib(UINib(nibName: "MsMyResidentListTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
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
        //chenglong
        return 3
        return self.dataArray.count
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! MsMyResidentListTableViewCell
        
        cell.backgroundColor = UIColor .whiteColor()
        
        //        let showModel  = self.dataArray .objectAtIndex(indexPath.section) as? NormOrderModel
        
        
        
        return cell
    }
    
    ///
    /// UITableViewDelegate
    ///
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView .deselectRowAtIndexPath(indexPath, animated:true )
        
        //        self.delegate? .didSelectOrder(MsOrderModel())
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
