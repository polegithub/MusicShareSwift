//
//  MsSinglePerformNormalTableView.swift
//  MusicShare
//
//  Created by poleness on 15/12/28.
//  Copyright © 2015年 poleness. All rights reserved.
//

import UIKit

class MsSinglePerformNormalTableView: UIView,UITableViewDataSource,UITableViewDelegate {
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    lazy var defaultView:UIView = self.initDefaultView()
    
    var dataArray = NSArray()
    
    var page = 0
    var totalPage = 0
    
    let cellIdentifier = "MsMyResidentStateListViewCell"
    
    //UI
    var tableView: UITableView?
    
    
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
        self.tableView = UITableView(frame: self.bounds, style :.Grouped)
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        self.tableView?.backgroundColor = UIColor.msBackGroundColor()
        self.tableView?.tableFooterView = UIView()
        
        self.tableView? .registerNib(UINib(nibName: "MsMyShowTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        self .addSubview(self.tableView!)
    }
    
    
    func updateData(data:NSArray){
        self.dataArray = data
        
        if data.count > 0 {
            if self.defaultView.superview != nil{
                self.defaultView.removeFromSuperview()
            }
        }else{
            self.tableView!.addSubview(self.defaultView)
        }
        self.tableView!.reloadData()
        
    }
    
    /**
     UITableViewDelegate
     
     */
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.dataArray.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! MsMyShowTableViewCell
        
        cell.backgroundColor = UIColor .whiteColor()
        
        let row = indexPath.row
        let showModel  = self.dataArray .objectAtIndex(row) as? MsShowModel
        
        if showModel != nil{
            cell.showTitle.text = showModel!.title
            if showModel!.imageUrl != nil{
                cell.showImg.image = UIImage(named: (showModel?.imageUrl)!)
            }else{
                //需要默认图片
                cell.showImg.image = UIImage(named: "temp_11")
            }
            if showModel?.shopName.characters.count > 0{
                cell.locationLabel.text = showModel!.shopName
            }else{
                cell.locationLabel.text = "北京 麻雀瓦舍"
                
            }
            
            if showModel?.timePeriod.characters.count > 0{
                cell.timeLabel.text = showModel!.timePeriod
            }else{
                cell.timeLabel.text = "2016-5-7"
            }
            
            if showModel?.singerInfo.characters.count >  0{
                cell.singerLabel.text = showModel?.singerInfo
            }else{
                cell.singerLabel.text = "布衣乐队"
            }
        }else{
            cell.showTitle.text = ""
            cell.showImg.image = UIImage()
            cell.locationLabel.text = ""
            cell.timeLabel.text = ""
        }
        return cell
    }
    
    ///
    /// UITableViewDelegate
    ///
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView .deselectRowAtIndexPath(indexPath, animated:true )
        
    }
    
    //默认视图
    func initDefaultView() -> UIView{
        let view = UIView(frame: self.bounds)
        
        let label = UILabel(frame: CGRectMake(15,40,self.width() - 30,40))
        label.font = UIFont .msCellFont()
        label.text = "暂无演出\n有新演出可点击右上角添加"
        label.numberOfLines = 0
        label.textColor = UIColor.lightGrayColor()
        label.textAlignment = NSTextAlignment.Center
        
        view.addSubview(label)
        
        return view
    }
    
}
