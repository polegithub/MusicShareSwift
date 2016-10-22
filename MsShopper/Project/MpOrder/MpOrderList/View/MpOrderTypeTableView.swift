//
//  MpOrderTypeTableView.swift
//  MusicShare
//
//  Created by poleness on 16/2/15.
//  Copyright © 2016年 poleness. All rights reserved.
//

import UIKit


protocol MpOrderTypeTableViewDelegate{
    func didselectOrderType(type:Int)
    
}

class MpOrderTypeTableView: UIView,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    let cellHeight:CGFloat = 40.0
    
    var currentType :Int = OrderType.normal //默认normal
    
    var delegate:MpOrderTypeTableViewDelegate?
    
    let cellIdentifier = "MpOrderTypeTableViewCell"

    var tableView:UITableView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initSubView()
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initSubView(){

        self.tableView = UITableView(frame: self.bounds)
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.scrollEnabled = false
        self.tableView?.backgroundColor = UIColor.whiteColor()
        self.tableView?.separatorStyle = UITableViewCellSeparatorStyle.None

        self.tableView?.reloadData()
        self.addSubview(self.tableView!)
        
        let blur = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = (self.tableView?.bounds)!
        self.tableView?.insertSubview(blurView, atIndex: 0)
        
        //gesture 
        self .addGestureRecognizer(self.gestureForDismissView())
    }
    
    func setOrderTypeShow(isShow:Bool){
        let height:CGFloat  = CGFloat(cellHeight * 3)
        let initX:CGFloat = CGFloat(kScreenWidth / 2 - 120 / 2)
        let hideFrame = CGRectMake(initX, -height, 120, height)
        let showFrame = CGRectMake(initX, 0, 120, height)
        if isShow {
            self.tableView?.frame = hideFrame
            self.hidden = false
            UIView .animateWithDuration(0.3, animations: { () -> Void in
                self.tableView?.frame = showFrame
                }, completion: { (finish) -> Void in
            })
        }else{
            self.tableView?.frame = showFrame
            UIView .animateWithDuration(0.3, animations: { () -> Void in
                self.tableView?.frame = hideFrame
                }, completion: { (finish) -> Void in
                self.hidden = true
            })
        }
        
        
        self.tableView!.reloadData()
    }
    
    
    /// UNIT
    
    //dismiss self view
    func gestureForDismissView()->UITapGestureRecognizer{
        let ges = UITapGestureRecognizer(target: self, action: Selector("dismissView"))
        ges.delegate = self
        return ges
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool{
        let point = touch.locationInView(self.tableView!)
        if (CGRectContainsPoint((self.tableView?.bounds)!, point)) {
            return false
        }
        
        return true
    }
    
    
    func dismissView(){
        self .setOrderTypeShow(false)
    }
    
    
    ///
    /// UITableViewDataSource
    ///
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0.1
        }
        return 15
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        
        if (cell == nil) {
            cell = UITableViewCell(style:UITableViewCellStyle.Value1, reuseIdentifier:cellIdentifier)
        }
        
        cell?.selectionStyle = UITableViewCellSelectionStyle.None
        cell?.contentView .removeAllSubviews()
        cell?.backgroundColor = UIColor.clearColor()
        
        let label = UILabel(frame: cell!.contentView.bounds)
        label.backgroundColor = UIColor.clearColor()
        
        cell?.contentView .addSubview(label)
        
        cell?.textLabel?.font = UIFont.systemFontOfSize(14)
        
        var title:String = ""
        if indexPath.row == OrderType.normal {
            title = "演出订单"
        }else if indexPath.row == OrderType.resident{
            title = "驻场订单"
        }else{
            title = "演出活动"
        }
        label.text = title
        label.textAlignment = NSTextAlignment.Center
        
        if indexPath.row == self.currentType {
            label.textColor = UIColor.msCommonColor()
        }else{
            label.textColor = UIColor.blackColor()
        }
        
        return cell!
    }
    
    
    
    ///
    /// UITableViewDelegate
    ///
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView .deselectRowAtIndexPath(indexPath, animated:true)
        
        self.currentType = indexPath.row
        self.delegate? .didselectOrderType(indexPath.row)
        self .setOrderTypeShow(false)
        
    }
    

}
