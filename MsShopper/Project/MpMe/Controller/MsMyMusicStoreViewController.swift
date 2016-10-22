//
//  MsMyMusicStoreViewController.swift
//  MusicShare
//
//  Created by poleness on 15/12/16.
//  Copyright © 2015年 poleness. All rights reserved.
//

import UIKit


class MsMyMusicStoreViewController: MsBaseViewController ,UITableViewDelegate,UITableViewDataSource{
    
    let MusicSheet = 0
    let Instrument = 1
    let MusicStudio = 2
    
    var apprArray = NSMutableArray()
    var dataArray = NSMutableArray()
    
    var paramsProtocolDelegate: ParamsProtocol?
    
    var navTitle:NSString = ""
    var navAlpha:CGFloat = 0.0
    
    //UI
    
    var tableView: UITableView!
    var headImgView:UIImageView?
    
    //图片浏览
    var photoView:MsPhotoBrowseViewController!
    
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //        self.setNavigationDefaultImage()
        //        self.setNavBacgroundWithAlpha(self.navAlpha)
        self.setNavigationTransparent(true)
        
        self.tableView?.delegate = self
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tableView?.delegate = nil //in case of crash
        
        self .setNavigationTransparent(false)
        //        self.setNavBacgroundWithAlpha(1.0)
        
    }
    
    func initView(){
        
        self.setNavigationTitle("我的小店")
        self.view.backgroundColor = UIColor.msBackGroundColor()
        
        self .setLeftBackImageWithWhite()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        
        self.tableView = UITableView(frame: CGRectMake(0, -64, kScreenWidth, kScreenHeight+64), style :.Grouped)
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        self.view .addSubview(self.tableView!)
        
        self.headImgView = UIImageView(frame: CGRectMake(0, 0, kScreenWidth, 150))
        self.headImgView!.image = UIImage(named: "temp_8")
        self.tableView?.tableHeaderView = self.headImgView
        
        //去掉导航栏的底部line
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.photoView = MsPhotoBrowseViewController()
        let frame = UIScreen.mainScreen().bounds
        self.photoView.view.frame = frame
    }
    
    //导航栏调整
    func setNavBacgroundWithAlpha(alpha:CGFloat)  {
        
        for view in (self.navigationController?.navigationBar.subviews)!{
            if view .isKindOfClass(NSClassFromString("_UINavigationBarBackground")!){
                
                view.alpha = alpha
                if alpha > 0 {
                    view.hidden = false
                }else{
                    view.hidden = true
                }
            }
        }
    }
    
    func updateNagivationBackground(){
        self.setNavBacgroundWithAlpha(self.navAlpha)
        
        let colorValue = 255 * self.navAlpha
        let color = UIColor(red: colorValue, green: colorValue, blue: colorValue, alpha: 1)
        self.navigationController?.navigationBar.tintColor = color
        
        
        let dict = NSDictionary(object: color, forKey: "NSForegroundColorAttributeName")
        self.navigationController?.navigationBar.titleTextAttributes = dict  as? [String : AnyObject]
        
    }
    
    
    //MARK:INIT
    
    
    
    
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
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifierNormal = "MsMyMusicStoreViewControllerCellNormal"
        
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifierNormal)
        
        if (cell == nil) {
            cell = UITableViewCell(style:UITableViewCellStyle.Value1, reuseIdentifier:cellIdentifierNormal)
        }
        
        
        cell?.textLabel?.font = UIFont.systemFontOfSize(15)
        cell?.detailTextLabel?.font = UIFont.systemFontOfSize(14)
        
        cell?.contentView .removeAllSubviews()
        
        cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        
        if indexPath.section == MusicSheet {
            cell?.textLabel?.text = "我的乐谱"
            cell?.detailTextLabel?.text = "暂无"
        }else if indexPath.section == Instrument {
            
            let label = UILabel(frame: CGRectMake(15,5,100,20))
            label.text = "我的乐器"
            label.font = UIFont.systemFontOfSize(15)
            cell?.contentView .addSubview(label)
            
            let width:CGFloat = 60
            let count = Int((kScreenWidth - 80) / 80)
            
            let view = UIView(frame: CGRectMake(15,30,kScreenWidth-30,70))
            
            for index in 0...count {
                let name = NSString(format: "temp_%d", index+1)
                
                let iniX:CGFloat = CGFloat(index * 70)
                let button:UIButton = UIButton(frame: CGRectMake(iniX, 0, width, width))
                button .setImage(UIImage(named: name as String), forState: UIControlState.Normal)
                button.tag = index
                button .addTarget(self, action: Selector("browsePictureForInsreument:"), forControlEvents: UIControlEvents.TouchUpInside)
                
                view .addSubview(button)
            }
            
            cell?.contentView .addSubview(view)
            
        }else{
            let label = UILabel(frame: CGRectMake(15,5,100,20))
            label.text = "店内环境"
            label.font = UIFont.systemFontOfSize(15)
            cell?.contentView .addSubview(label)
            
            let width:CGFloat = 60
            let count = Int((kScreenWidth - 80) / 80)
            
            let view = UIView(frame: CGRectMake(15,30,kScreenWidth-30,70))
            
            for index in 0...count {
                let name = NSString(format: "loc_%d", index+1)
                
                let iniX:CGFloat = CGFloat(index * 70)
                let button:UIButton = UIButton(frame: CGRectMake(iniX, 0, width, width))
                button .setImage(UIImage(named: name as String), forState: UIControlState.Normal)
                button.tag = index
                button .addTarget(self, action: Selector("browsePictureForStore:"), forControlEvents: UIControlEvents.TouchUpInside)
                
                view .addSubview(button)
            }
            
            cell?.contentView .addSubview(view)
        }
        
        
        return cell!
        
    }
    
    ///
    /// UITableViewDelegate
    ///
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == MusicSheet {
            return 44
        }
        return 100
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView .deselectRowAtIndexPath(indexPath, animated:true )
      
        if indexPath.section > MusicSheet {
            self.enterPciutreListView(indexPath.section)
        }
    }
    
    //MARK : UIScrollview delegate
    //    func scrollViewDidScroll(scrollView: UIScrollView) {
    //
    //        //调整导航栏的颜色
    //        if (scrollView.contentOffset.y > 0) {
    //            var offset = fabs(scrollView.contentOffset.y);
    //            if (offset > 64) {
    //                offset = 64;
    //            }
    //            self.navAlpha = offset / 64; //因为是反的，所以1-
    //
    //        } else {
    //            self.navAlpha = 0;
    //        }
    //
    //        self.updateNagivationBackground()
    //    }
    
    
    // MARK: searchbardelegae
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        let searchVC = MsSearchMainViewController()
        self .hidePushViewController(searchVC, animated: true)
        
        return false
    }
    
    
    //Mark : Action
    
    //浏览图片
    func browsePictureForInsreument(button:UIButton){
        
        self.photoView.initImageArray(self.imageArray(Instrument))
        self.photoView.currentIndex = button.tag
        
        let window = UIApplication.sharedApplication().keyWindow
        window! .addSubview(self.photoView.view)
        
    }
    
    func browsePictureForStore(button:UIButton){
        self.photoView.initImageArray(self.imageArray(MusicStudio))
        self.photoView.currentIndex = button.tag
        
        let window = UIApplication.sharedApplication().keyWindow
        window! .addSubview(self.photoView.view)
    }
    
    
    
    
    //PHOTO ARRAY
    func imageArray(index :Int)->NSArray{
        let array_M = NSMutableArray()
        
        let count = Int((kScreenWidth - 80) / 80)
        var namePre:String = ""
        if index == Instrument {
            namePre = "temp_"
        }else if index == MusicStudio {
            namePre = "loc_"
        }
        
        for index in 0...count {
            let name = NSString(format: "%@%d",namePre,index+1)
            let image = UIImage(named: name as String)
            array_M .addObject(image!)
        }
        
        return NSArray(array: array_M)
    }
    
    //进入图片子页面
    func enterPciutreListView(index:Int){
        let subVC = MsPhotoListViewController()
        subVC.dataSource = self.imageArray(index)
        self.hidePushViewController(subVC, animated: true)
    }
    
    
    //网络请求
    func requestFotData(){
        //        if incremental{
        //            self.page >= self.totalPage
        //            return
        //        }else{
        //            self.page++
        //        }
        
        for index in 1...4 {
            var text : NSString
            if index % 2 == 0{
                text = "一直很喜欢这个曲子，一路挺过来..为了梦想"
            }else{
                text = "路过打个酱油，支持 痛痒，支持！！！！"
            }
            self.apprArray .addObject(text)
        }
        
        self.tableView?.reloadData()
        
    }
    
    
}
