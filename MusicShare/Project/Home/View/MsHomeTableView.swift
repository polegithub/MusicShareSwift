//
//  MsHomeView.swift
//  MusicShare
//
//  Created by poleness on 16/1/17.
//  Copyright © 2016年 poleness. All rights reserved.
//

import UIKit

protocol HomeTableViewDelegate{
    func refreshHomeData()
    func reloadMoreHomeData()
    func didSelectNav(tag:Int)
}

class MsHomeTableView: UIView ,UITableViewDelegate,UITableViewDataSource,PullTableViewDelegate{
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
    let navSection = 0
    
    var delegate:HomeTableViewDelegate?
    
    var menuArray = NSArray()
    var dataArray = NSArray()
    var navArray = NSArray()
    var bannerArray = NSArray()
    
    var bannerView:UIScrollView = UIScrollView()
    var tableView: PullTableView?
    
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        self .initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //        fatalError("init(coder:) has not been implemented")
    }
    
    //更新数据
    //    func reloa
    
    func initView(){
        self.bannerView = UIScrollView(frame: CGRectMake(0,0,kScreenWidth,88))
        self.bannerView.showsVerticalScrollIndicator = false
        self.updateBanner()
        
        self.tableView = PullTableView(frame:self.bounds, style :.Grouped)
        
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        self.tableView!.pullDelegate = self
        self.tableView?.tableHeaderView = self.bannerView
        
        self.tableView?.loadMoreView .setBackgroundColor(UIColor.msBackGroundColor(), textColor: UIColor.lightGrayColor(), arrowImage: nil, finishText: "更多精彩，敬请期待")
        
        self .addSubview(self.tableView!)
        
    }
    
    func updateBanner(){
        
        let data = NSUserDefaults.standardUserDefaults() .objectForKey(kuserDefaultBannerData) as? NSData
        if data != nil{
            self.bannerArray = NSKeyedUnarchiver.unarchiveObjectWithData(data!) as! NSArray
        }
        self.bannerView .removeAllSubviews()
        
        if self.bannerArray.count > 0 {
            
            for item  in self.bannerArray{
                
                let bannerModel :MsBannerModel = item as! MsBannerModel
                let index :Int = self.bannerArray .indexOfObject(item)
                if bannerModel.bannerUrl.characters.count  > 0 {
                    let img = UIImageView(image: UIImage(named: bannerModel.bannerUrl ))
                    //                    img.backgroundColor = UIColor.redColor()
                    img.frame = CGRectMake(CGFloat(index) * kScreenWidth,0 ,kScreenWidth,88)
                    img.setImageWithURL(NSURL(string: bannerModel.bannerUrl)!, placeholderImage: UIImage(named: "icon.png"))

                    self.bannerView .addSubview(img)
                }
            }
            
            let width:CGFloat =  CGFloat( self.bannerArray.count) * CGFloat( kScreenWidth)
            self.bannerView.contentSize = CGSizeMake(width, 88)
        }
        
        
    }
    
    
    
    func navView()->UIView{
        let view = UIView(frame: CGRectMake(0,0,kScreenWidth,100))

        
        let gap:CGFloat = (kScreenWidth - 44 * 4 ) / 5
        let avgGap:CGFloat = kScreenWidth / 4
        
        for var i = 0; i < self.navArray.count ; i++ {
            let navModel = self.navArray .objectAtIndex(i) as! MsNavModel
            
            let button  = UIButton(frame: CGRectMake(gap * CGFloat(i+1) + 44 * CGFloat(i), 20, 44, 44))

            button.setImageForState(UIControlState.Normal, withURL: NSURL(string: navModel.navUrl)!, placeholderImage: UIImage(named: "temp_2"))
            
            button.layer.cornerRadius = 22.0
            button.clipsToBounds = true
            button.tag = i
            
            let titleBtn = UIButton(frame: CGRectMake(CGFloat(i ) * avgGap,70,avgGap,20))
            let title = navModel.navName
            
            let point = titleBtn.center
            titleBtn.center = CGPointMake(button.center.x,point.y)
            
            titleBtn.titleLabel?.font = UIFont.systemFontOfSize(15)
            titleBtn .setTitle(title, forState: UIControlState.Normal)
            titleBtn .setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            titleBtn.tag = i
            
            button .addTarget(self, action: Selector("enterNavView:"), forControlEvents: UIControlEvents.TouchUpInside)
            titleBtn .addTarget(self, action: Selector("enterNavView:"), forControlEvents: UIControlEvents.TouchUpInside)
            
            view .addSubview(button)
            view.addSubview(titleBtn)
        }
        
        return view
        
    }
    
    func enterNavView(button:UIButton){
        
        self.delegate? .didSelectNav(button.tag)
    }
    
    //导航的行数
    func linesOfNav()->Int{
        let count = self.navArray.count
        var currentLine:Int = count / 4
        let left = count % 4
        if left > 0{
            currentLine++
        }
        
        return currentLine
    }
    
    
    
    // MARK:tableviewdelegate
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1;
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.menuArray.count + 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == navSection{
            return 1
        }
        return self.menuArray[section-1].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "MsHomeViewControllerCell"
        
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        
        if (cell == nil) {
            cell = UITableViewCell(style:UITableViewCellStyle.Value1, reuseIdentifier:cellIdentifier)
        }
        
        cell!.backgroundColor = UIColor .whiteColor()
        
        var section = indexPath.section
        let row = indexPath.row
        
        cell?.contentView .removeAllSubviews()
        cell?.imageView?.image = nil
        
        cell?.textLabel?.numberOfLines = 0
        cell?.textLabel?.font = UIFont.systemFontOfSize(15.0)
        
        cell?.textLabel?.text = ""
        cell?.detailTextLabel?.text = ""
        
        if section == navSection {
            cell?.contentView .addSubview(self.navView())
            
        }else  {
            section = section - 1
            let array = self.menuArray[section] as! NSArray
            if row < array.count{
                let dic = array[row] as! NSDictionary
                let imgName = dic.objectForKey("image") as! NSString
                
                if row == 0 {
                    
                    let image = UIImageView(frame: CGRectMake(15, 0, kScreenWidth-30, 140))
                    //                  image.contentMode = UIViewContentMode.ScaleAspectFill
                    image.image = UIImage(named: imgName as String)
                    
                    cell?.contentView .addSubview(image)
                    cell?.textLabel?.text = nil
                    
                } else {
                    let text = dic.objectForKey("text") as! NSString
                    cell!.textLabel!.text = text as String
                    
                    if row % 3 == 0 {
                        cell?.imageView?.image = UIImage(named: imgName as String)
                        
                    }
                }
            }
            
        }
        
        return cell!
    }
    
    ///
    /// UITableViewDelegate
    ///
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == navSection {
            return CGFloat(self.linesOfNav()) * 100.0
        }else if indexPath.row == 0 {
            return 140
        }
        return  44
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView .deselectRowAtIndexPath(indexPath, animated:true )
        //        var index = indexPath.row
        //        var data = self.dataSource[index] as! NSDictionary
        //
        //        let comment = CommentController()
        //        comment.jokeId = data["id"] as? String
        //        self.navigationController?.pushViewController(comment, animated: true)
    }
    
    
    func pullTableViewDidTriggerLoadMore(pullTableView: PullTableView!) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), { () -> Void in
            self.tableView?.pullTableIsLoadingMore = false
            self.tableView?.isFinished = true
            
            self.delegate?.refreshHomeData()
        });
    }
    
    func pullTableViewDidTriggerRefresh(pullTableView: PullTableView!) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), { () -> Void in
            self.tableView?.pullTableIsRefreshing = false
            self.delegate?.reloadMoreHomeData()
        });
    }
}
