//
//  MsMyFollowViewController.swift
//  MusicShare
//
//  Created by poleness on 15/12/15.
//  Copyright © 2015年 poleness. All rights reserved.
//

import UIKit

class MsMyFollowViewController: MsBaseViewController,UITableViewDataSource,UITableViewDelegate {
    
    //data
    var dataSource = NSMutableArray()
    
    var tableView: UITableView?
    
    let cellIdentifier = "MsMyFollowViewControllerCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initView(){
        
        self.setLeftBackImageWithWhite()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        self.tableView = UITableView(frame: CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 ), style :.Plain)
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        self.view .addSubview(self.tableView!)
        
        self.tableView? .registerNib(UINib(nibName: "MsMyFollowTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        self .setNavigationTitle("我的关注")
        self .setNavigationMusicianImage()
        
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    ///
    /// UITableViewDataSource
    ///
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 20
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! MsMyFollowTableViewCell
        
        cell.backgroundColor = UIColor .whiteColor()
        
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        let value = indexPath.row > 11 ? indexPath.row - 11 :indexPath.row + 1
        let temp = NSString(format: "temp_%d", value)
        
        cell.userPhoto.image  = UIImage(named: temp as String)
        
        cell.userName.text = "张佳玮写字的地方"
        cell.psSignLabel.text = "一首歌的故事，带给我一个代购指南..."
        
        return cell
    }
    
    ///
    /// UITableViewDelegate
    ///
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return  60
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView .deselectRowAtIndexPath(indexPath, animated:true )
        
        let subVC =  MsMusicianMainViewController()
        self.hidePushViewController(subVC, animated: true)
        
    }
    
    
    
}
