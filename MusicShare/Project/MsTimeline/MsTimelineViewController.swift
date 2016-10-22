//
//  MsConcernViewController.swift
//  MusicShare
//
//  Created by poleness on 15/12/2.
//  Copyright © 2015年 poleness. All rights reserved.
//

import UIKit

enum TimelineSource:Int {
    case FromTabbar = 0     //TABBAR根视图
    case FromMe = 1         //我的timeline
}

class MsTimelineViewController: MsBaseViewController ,UITableViewDelegate,UITableViewDataSource{
    
    //source
    var source:TimelineSource?
    
    var menuArray = NSMutableArray()
    var dataArray = NSMutableArray()
    
    var page = 0
    var totalPage = 0
    
    //UI
    var tableView: UITableView?
    let cellIdentifier = "MsTimelineViewControllerCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.source == TimelineSource.FromTabbar {
            self.setNavigationTitle("关注")
        }else{
            self.setNavigationTitle("我的关注")
            self.setLeftBackImageWithWhite()
        }
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        self.initView()
        self .requestFotData()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.hidesBottomBarWhenPushed = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setNavigationMusicianImage()
    }
    
    func initView(){
        self.edgesForExtendedLayout = UIRectEdge.None
        
        var height = kScreenHeight - 49 - 64
        if self.source == TimelineSource.FromMe {
            height = kScreenHeight - 64
        }
        
        self.tableView = UITableView(frame: CGRectMake(0, 0, kScreenWidth,height), style :.Grouped)
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        self.view .addSubview(self.tableView!)
        
        self.tableView? .registerNib(UINib(nibName: "MsTimelineTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    // MARK:tableviewdelegate
//    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 0.1;
//    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! MsTimelineTableViewCell
        
        let row = indexPath.row
        
        cell.backgroundColor = UIColor .whiteColor()
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = UIFont.systemFontOfSize(15.0)
        
        let dic = self.dataArray[row] as! NSDictionary
        let imgName = dic.objectForKey("image") as! NSString
        let comment = dic.objectForKey("text") as! NSString
        let user = dic.objectForKey("name") as! NSString
        
        if self.source == TimelineSource.FromTabbar {
            cell.userPhoto.image = UIImage(named: imgName as String)
            cell.userName.text = user as String

        }else {
            cell.userPhoto.image = UIImage(named: "temp_9")
            cell.userName.text = "在下"

        }
        cell.userComment.text = comment as String
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        // Date 转 String
        let temp = NSTimeInterval(arc4random_uniform(10000))
        let date = NSDate(timeIntervalSinceNow: temp)
        let nowString = dateFormatter.stringFromDate(date)
        cell.sendTime.text = nowString
        
        if indexPath.row % 3 == 1{
            cell.additionView.hidden = true
        }else{
            cell.additionView.hidden = false
        }
        
        
        return cell
    }
    
    ///
    /// UITableViewDelegate
    ///
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //        var index = indexPath.row
        //        var data = self.dataSource[index] as! NSDictionary
        //
        if indexPath.row % 3 == 0{
            let rand = CGFloat(arc4random_uniform(100) + 100)
            return  rand
        }else if indexPath.row % 3 == 1 {
            return 75.0
        }else{
            return  150
            
        }
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
    
    
    // MARK: searchbardelegae
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        let searchVC = MsSearchMainViewController()
        self .hidePushViewController(searchVC, animated: true)
        
        return false
    }
    
    
    
    //网络请求
    func requestFotData(){
        //        if incremental{
        //            self.page >= self.totalPage
        //            return
        //        }else{
        //            self.page++
        //        }
        
        
        for (var j = 0;j < 10;j++){
            
            if j % 2 == 0{
                let dic = NSMutableDictionary()
                dic.setObject("rock and roll also called rock music", forKey: "text")
                
                let tempName = NSString(format: "user_%d", arc4random_uniform(100) )
                dic.setObject(tempName, forKey: "name")
                
                let temp = NSString(format: "temp_%d", arc4random_uniform(12) + 1)
                dic.setObject(temp, forKey: "image")
                
                self.dataArray .addObject(dic)
            }else{
                let dic = NSMutableDictionary()
                
                let tempName = NSString(format: "Mr_%d", arc4random_uniform(100) )
                dic.setObject(tempName, forKey: "name")
                
                dic.setObject("Music share and start the world", forKey: "text")
                let temp = NSString(format: "temp_%d", arc4random_uniform(12) + 1)
                dic.setObject(temp, forKey: "image")
                
                self.dataArray .addObject(dic)
                
            }
            
        }
        
        
        self.tableView?.reloadData()
        
    }
    
    
}
