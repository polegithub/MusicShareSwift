//
//  MsMusicianMainViewController.swift
//  MusicShare
//
//  Created by poleness on 15/12/6.
//  Copyright © 2015年 poleness. All rights reserved.
//

import UIKit


let followSection = 0
//let addressSection = 1
let demoSection = 1

class MsMusicianMainViewController: MsBaseViewController,UITableViewDelegate,UITableViewDataSource{
    
    var musicUserId:String? = ""
    var musicianInfo:MsUserModel = MsUserModel()
    
    var menuArray = NSMutableArray()
    var dataArray = NSMutableArray()
    
    //UI
    var tableView: UITableView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
        
        self.requestFotData()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.setNavigationMusicianImage()
        self .setNavigationTransparent(false)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setNavigationDefaultImage()
        self.setNavigationTransparent(true)
        
        //        self.tableView?.contentOffset = CGPointMake(0, kScreenHeight - 128)
        
    }
    
    func initView(){
        self.edgesForExtendedLayout = UIRectEdge.All
        self .setLeftBackImageWithWhite()
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.view.backgroundColor = UIColor.msBackGroundColor()
        
        self.tableView = UITableView(frame: CGRectMake(0, 0, kScreenWidth, kScreenHeight+64), style :.Grouped)
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        self.tableView!.backgroundColor = UIColor.clearColor()
        self.tableView!.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        
        self.tableView?.tableHeaderView = self.headerView()
        self.tableView?.backgroundColor = UIColor.clearColor()
        
        
        //背景
        let backImg = UIImageView(frame: CGRectMake(0, 0, kScreenWidth, kScreenHeight))
        backImg.image = UIImage(named: "temp_4")
        
        let blur = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = (backImg.bounds)
        backImg .addSubview(blurView)
        
        
        self.view! .addSubview(backImg)
        //        self.view.backgroundColor = UIColor.orangeColor()
        
        self.view .addSubview(self.tableView!)
        
    }
    
    func headerView()->UIView{
        let view = UIView(frame: CGRectMake(0,0,kScreenWidth,64 * 3))
        
        //头像
        let photoInitY = view.height() - 60 - 44
        let photoImg = UIImageView(frame: CGRectMake(kScreenWidth/2 - 60/2, photoInitY, 60, 60))
        photoImg.image = UIImage(named: "temp_9")
        photoImg.layer.cornerRadius = 30
        photoImg.layer.borderColor = UIColor.whiteColor().CGColor
        photoImg.layer.borderWidth = 3
        photoImg.clipsToBounds = true
        
        //名字
        let nameLabel = UILabel(frame: CGRectMake(15,photoInitY + 70, kScreenWidth-30,20))
        nameLabel.font = UIFont.systemFontOfSize(14)
        nameLabel.textAlignment = NSTextAlignment.Center
        nameLabel.textColor = UIColor.whiteColor()
        
        nameLabel.text = self.musicianInfo.userName
        //        let size = nameLabel.text!.textSize(13, maxWidth: CGSizeZero.width, maxHeight: CGSizeZero.height)
        //        let blur = UIBlurEffect(style: UIBlurEffectStyle.Light)
        //        let blurView = UIVisualEffectView(effect: blur)
        //        blurView.frame = CGRectMake(nameLabel.width() / 2 - size.width/2,nameLabel.height()/2 - size.height/2,size.width,size.height)
        //        nameLabel . addSubview(blurView)
        
        view .addSubview(nameLabel)
        view.addSubview(photoImg)
        
        return view
        
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    
    /**
    Unit
    */
    func followeLable(index:Int)->UILabel{
        let initX:CGFloat = kScreenWidth / 3
        //        let initX:Float = Float( width * index)
        //        let offsetX = Float(Float(index) * kScreenWidth)
        
        let label = UILabel(frame: CGRectMake(initX,0,kScreenWidth / 3,44))
        return label;
    }
    
    
    
    // MARK:tableviewdelegate
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1;
    }
    
    //    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    //        let view = UIView(frame: CGRectMake(0,0,kScreenWidth,30));
    //        view.backgroundColor = UIColor.msBackGroundColor()
    //        return view
    //    }
    //
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        if section == followSection {
            return 30
        }else if section == demoSection{
            return 0.1
        }
        return 15
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var number:Int
        
        switch(section){
        case followSection:
            number = 1
            break
        case demoSection:
            number = 2
            break
        default:
            number = 1
        }
        
        return  number
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "MsMusicianMainViewControllerCell"
        
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        
        if (cell == nil) {
            cell = UITableViewCell(style:UITableViewCellStyle.Value1, reuseIdentifier:cellIdentifier)
        }
        
        cell?.contentView .removeAllSubviews()
        
        cell?.selectionStyle = UITableViewCellSelectionStyle.None
        //        let blur = UIBlurEffect(style: UIBlurEffectStyle.Light)
        //        let blurView = UIVisualEffectView(effect: blur)
        //        blurView.frame = (cell?.bounds)!
        
        cell?.backgroundColor = UIColor.clearColor()
        //        cell?.backgroundView = blurView
        
        let section = indexPath.section
        let row = indexPath.row
        
        cell?.imageView?.image = nil
        
        let font = UIFont .systemFontOfSize(13)
        
        cell?.textLabel?.font = font
        cell?.textLabel?.textColor = UIColor.whiteColor()
        cell?.detailTextLabel?.font = font
        
        cell?.textLabel?.numberOfLines = 0
        
        if section == followSection {
            let width  = kScreenWidth / 3
            let color = UIColor.whiteColor()
            
            
            let showCount = UILabel(frame: CGRectMake(0,0,width,44))
            showCount.font = font
            showCount.text = "2355\n场演出"
            showCount.numberOfLines = 0
            showCount.textAlignment = NSTextAlignment.Center
            showCount.textColor = color
            
            let following = UILabel(frame: CGRectMake(width,0,width,44))
            
            following.font = font
            following.text = "349\n关注"
            following.numberOfLines = 0
            following.textAlignment = NSTextAlignment.Center
            following.textColor = color
            
            let follower = UILabel(frame: CGRectMake(width * 2,0,width,44))
            follower.font = font
            follower.text = "3.5w\n粉丝"
            follower.numberOfLines = 0
            follower.textAlignment = NSTextAlignment.Center
            follower.textColor = color
            
            cell?.contentView.backgroundColor = UIColor.clearColor()
            cell?.selectionStyle = UITableViewCellSelectionStyle.None
            
            cell?.contentView .addSubview(showCount)
            cell?.contentView .addSubview(following)
            cell?.contentView .addSubview(follower)
            
        }else if section == demoSection{
            if row  == 0 {
                cell?.textLabel?.text = "我的Demo"
                cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            }else if row == 1{
                cell?.textLabel?.text = "我的视频"
                cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            }
            
        }
        
        return cell!
    }
    
    ///
    /// UITableViewDelegate
    ///
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return  44
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView .deselectRowAtIndexPath(indexPath, animated:true )
        let section = indexPath.section
        let row = indexPath.row
        
        if section == demoSection{
            if row == 0 {
                let subVC = MsMyMusicViewController()
                self.hidePushViewController(subVC, animated: true)
            }else{
                let subVC = MsMyVideoViewController()
                self.hidePushViewController(subVC, animated: true)
            }
        }
    }
    
    
    
    //网络请求
    func requestFotData(){
        //        if incremental{
        //            self.page >= self.totalPage
        //            return
        //        }else{
        //            self.page++
        //        }
        
        //        self.setNavigationTitle("音乐人")
        
        self.dataArray .removeAllObjects()
        
        for (var i=0; i<2;i++){
            
            for (var j = 0;j < 2 ;j++){
                if j % 2 == 0{
                    let dic = NSMutableDictionary()
                    dic.setObject("rock and roll also called rock music", forKey: "text")
                    let temp = NSString(format: "temp_%d", arc4random_uniform(12) + 1)
                    dic.setObject(temp, forKey: "image")
                    //                    array_M .addObject(dic)
                    self.dataArray .addObject(dic)
                }else{
                    let dic = NSMutableDictionary()
                    dic.setObject("Music share and start the world", forKey: "text")
                    let temp = NSString(format: "temp_%d", arc4random_uniform(12) + 1)
                    dic.setObject(temp, forKey: "image")
                    //                    array_M .addObject(dic)
                    self.dataArray .addObject(dic)
                    
                }
            }
            
            //            self.menuArray .addObject(array_M)
        }
        
        self.tableView?.reloadData()
        
    }
    
}
