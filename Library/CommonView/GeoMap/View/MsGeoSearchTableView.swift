//
//  MsGeoSearchResultTableView.swift
//  MusicShare
//
//  Created by poleness on 15/12/30.
//  Copyright © 2015年 poleness. All rights reserved.
//

import UIKit


protocol MsGeoSearchResultDelegate{
    func didSelectAddress(address:AMapPOI)
}


class MsGeoSearchResultTableView: UIView ,UITableViewDataSource,UITableViewDelegate{
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
    var delegate :MsGeoSearchResultDelegate?
    
    var dataArray = NSArray()
    
    
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
        self.tableView = UITableView(frame: self.bounds, style :.Plain)
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        self.tableView?.backgroundColor = UIColor.msBackGroundColor()
        self.tableView?.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
        
        self.tableView?.tableFooterView = UIView()
        
        self .addSubview(self.tableView!)
    }
    
    
    func updateData(data:NSArray){
        self.dataArray = data
        self.tableView!.reloadData()
        
    }
    
    /**
     UITableViewDelegate
     
     */
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "附近地址"
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "MsGeoSearchResultTableViewCell"
        
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        
        if (cell == nil) {
            
            cell = UITableViewCell(style:UITableViewCellStyle.Subtitle, reuseIdentifier:cellIdentifier)
            
        }
        cell!.backgroundColor = UIColor .whiteColor()
        
        cell?.textLabel?.font = UIFont.msCellFont()
        
        let model = self.dataArray .objectAtIndex(indexPath.row) as! AMapPOI
        
        cell?.textLabel?.textColor = UIColor.msCommonColor()
        
        cell?.textLabel?.text = model.name
        cell?.detailTextLabel?.text = model.address
        
        return cell!
    }
    
    ///
    /// UITableViewDelegate
    ///
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 66
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView .deselectRowAtIndexPath(indexPath, animated:true )
        
        if indexPath.row < self.dataArray.count {
            self.delegate? .didSelectAddress(self.dataArray .objectAtIndex(indexPath.row) as! AMapPOI)
        }
    }
    
    
}
