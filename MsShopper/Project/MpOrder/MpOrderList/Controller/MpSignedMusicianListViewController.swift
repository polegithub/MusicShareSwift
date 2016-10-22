//
//  MpSignedMusicianListViewController.swift
//  MusicShare
//
//  Created by poleness on 16/2/26.
//  Copyright © 2016年 poleness. All rights reserved.
//

import UIKit

class MpSignedMusicianListViewController: MsBaseViewController ,UITableViewDelegate,UITableViewDataSource,PullTableViewDelegate{

    //UI
    let cellIdentifier = "MpSignedMusicianListCell"
    var tableView:PullTableView!
    
    //data
    var orderData:NormOrderModel!
    var dataArray:NSArray = NSArray()
    
    //refresh data
    var currentPage:Int = 1
    var totalPage:Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initView()
        self.initData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initView(){
        self.view .backgroundColor = UIColor.msBackGroundColor()
        self .setLeftBackImageWithWhite()
        self.setNavigationTitle("已报名乐手")
        
        self.tableView = PullTableView(frame:CGRectMake(0,0,kScreenWidth,kScreenHeight), style: UITableViewStyle.Grouped)
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.pullDelegate = self
        
        self.tableView! .registerNib(UINib(nibName: "MpSignedMusicianTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.tableView!.backgroundColor = UIColor.clearColor()
        
        
        self.tableView?.loadMoreView .setBackgroundColor(UIColor.msBackGroundColor(), textColor: UIColor.lightGrayColor(), arrowImage: nil, finishText: "没有更多了...")
        
        self.view .addSubview(self.tableView!)
        
    }
    
    func initData(){
        self.requestForSelectMusician()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    /// UI
    
    //star view
    func startView(starScore:Int)->UIView{
        let view = UIView(frame: CGRectMake(0,0,108,24))
        view.backgroundColor = UIColor.clearColor()
        
        
        
        return view
    }
    
    ///
    /// UITableViewDataSource
    ///
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return self.dataArray.count
        return 5
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! MpSignedMusicianTableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        if self.dataArray.count > indexPath.section{
         
            let model = self.dataArray .objectAtIndex(indexPath.section) as! MsUserModel
            
            cell.enterSubBtn.tag = Int(model.userId)!
            cell.enterSubBtn .addTarget(self, action: Selector("enterMusicianDetailView:"), forControlEvents: UIControlEvents.TouchUpInside)
            
            cell.musicianName.text = model.userName
            
            if model.photoUrl.characters.count > 0 {
                cell.photoImage .setImageWithURL(NSURL(string: model.photoUrl)!, placeholderImage: UIImage(named: "temp_12"))
            }else{
                cell.photoImage.image = UIImage(named: "temp_12")
            }
            
            
            cell.startBackView .removeAllSubviews()
            cell.startBackView .addSubview(self.startView(model.starScore))
        }
        
        
        
        return cell
    }
    
    
    ///
    /// UITableViewDelegate
    ///
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return  120
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView .deselectRowAtIndexPath(indexPath, animated:true)
        
//        let model = self.dataArray .objectAtIndex(indexPath.section)
//        self.delegate?.didSelectNormalOrder(model as! NormOrderModel)
        
    }
    
    //load more
    func pullTableViewDidTriggerLoadMore(pullTableView: PullTableView!) {
        //        self.delegate? .loadModeWholeOrderListData()
    }
    
    func pullTableViewDidTriggerRefresh(pullTableView: PullTableView!) {
        self.tableView?.isFinished = true
        //        self.delegate? .refreshWholeOrderListData()
    }
    
    
    /**
    *  Action
    */
    
    //进入子页面
    func enterMusicianDetailView(button:UIButton){
        let sub = MsMusicianMainViewController()
        sub.musicUserId = String(button.tag)
        self.hidePushViewController(sub, animated: true)
    }
    
    //选定歌手
    func selectorMusician(button:UIButton){
        
    }
    
    //移除歌手
    func removeMusician(button:UIButton){
        
    }
    
    
    /**
    *  Internet
    */
    
   func requestForSelectMusician(){
    let request = MsRequestModel.requestForSignUpMusicianListOfOrder(userMgr.userInfo.userId, page: String(self.currentPage), orderId: self.orderData.orderId, timeId: self.orderData.timeId)
    
    netWorkMgr.post(request) { (status, result) -> Void in
        if status == "ok"{
            if result != nil{
                let playBoard = (result!["payload"] as? NSDictionary)!
                let musicianList = playBoard .objectForKey("content") as! NSArray
                
                for item in musicianList{
                    
                }
                
//                self.mpOrder = NormOrderModel(orderData: playBoard)
//                self.tableView.reloadData()
            }
        }
    
    }
    }

}
