//
//  MpOrderDetailViewController.swift
//  MusicShare
//
//  Created by poleness on 16/2/24.
//  Copyright © 2016年 poleness. All rights reserved.
//

import UIKit

class MpOrderDetailViewController: MsBaseViewController,UITableViewDelegate,UITableViewDataSource,PullTableViewDelegate {
    
    let titleSection = 0
    let priceSection = 1
    let timeSection = 2
    let shopSection = 3
    let musicianSection = 4
    
    
    let IMAGE_HEIGHT:CGFloat = kScreenWidth * 0.8
    
    //data
    var mpOrder:NormOrderModel?
    
    //UI
    var tableView: PullTableView!
    
    //UI-frame
    var styleLines:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationShopperImage()
        
        self.requestForOrderDetail()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func initView(){
        self.view.backgroundColor = UIColor.msBackGroundColor()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        self .setLeftBackImageWithWhite()
        
        self .setNavigationTitle("订单详情")
        
        self.tableView = PullTableView(frame: CGRectMake(0, 0, kScreenWidth, kScreenHeight-64), style :.Grouped)
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        self.tableView.pullDelegate = self
        self.tableView.isFinished = true
        
        self.tableView.backgroundColor = UIColor.clearColor()
        
        self.view .addSubview(self.tableView!)
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    
    //UI
    // base unit
    func baseLabel(frame:CGRect)->UILabel{
        let label = UILabel(frame: frame)
        label.font = UIFont.systemFontOfSize(15)
        label.textColor = UIColor.lightGrayColor()
        label.numberOfLines = 0
        
        return label
    }
    
    // 标签 风格
    func styleView()->UIView{
        //风格标签
        let view = UIView(frame: CGRectMake(80,0,kScreenWidth - 100,44))
        if self.mpOrder == nil || self.mpOrder!.styleArray.count == 0{
            return UIView()
        }
        
        self.styleLines = 1
        let array = self.mpOrder!.styleArray
        var widthSum:CGFloat = 0
        
        for item in array{
            let model = item as! MpStyleModel
            let width = model.styleName.textSize(15, maxWidth: 100, maxHeight: 20).width + 10
            if widthSum > kScreenWidth - 30 - width - 15 {
                styleLines += 1
                widthSum = 0
            }
            let initY = CGFloat(styleLines - 1) * 40 + 10
            
            let label = self.baseLabel(CGRectMake(widthSum+15,initY,width,24))
            label.textColor = UIColor.msCommonColor()
            label.textAlignment = NSTextAlignment.Center
            label.layer.borderColor = UIColor.msCommonColor().CGColor
            label.layer.borderWidth = 0.5
            label.text = model.styleName
            
            view .addSubview(label)
            //每行累加
            widthSum  += width + 15
        }
        
        return view
        
    }
    
    //title desc
    func titleHeight()->CGFloat{
        
        let width = CGFloat(kScreenWidth - cellLeftMargin * 2)
        
        let heightTitle:CGFloat = self.mpOrder!.title .textSize(15, maxWidth:width, maxHeight: 0).height
        return heightTitle
    }
    
    func descHeight()->CGFloat{
        let width = CGFloat(kScreenWidth - cellLeftMargin * 2)
        
        let heightDesc:CGFloat = self.mpOrder!.orderDesc .textSize(15, maxWidth:width, maxHeight: 0).height
        return heightDesc
    }
    
    ///
    /// UITableViewDataSource
    ///
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        if section == titleSection {
            return 0.1
        }
        return 10
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == titleSection {
            return 1
        }else if section == priceSection{
            return 1
        }else if section == timeSection{
            return 2
        }else if section == shopSection{
            return 2
        }else{
            return 2
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "orderDetailTransporterInfoTel"
        
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        
        if (cell == nil) {
            
            cell = UITableViewCell(style:UITableViewCellStyle.Value1, reuseIdentifier:cellIdentifier)
        }
        
        cell!.textLabel!.font = UIFont.systemFontOfSize(15.0)
        cell!.detailTextLabel?.font = UIFont.systemFontOfSize(14.0)
        
        //        cell?.textLabel?.textColor = UIColor.whiteColor()
        //        cell?.detailTextLabel?.textColor = UIColor.whiteColor()
        
        cell?.textLabel?.text = ""
        cell?.imageView?.image = nil
        
        cell?.accessoryType = UITableViewCellAccessoryType.None
        
        cell?.contentView .removeAllSubviews()
        
        let section = indexPath.section
        let row = indexPath.row
        
        if self.mpOrder == nil{
            return cell!
        }
        
        
        if section == titleSection{
            //image
            let img = UIImageView(frame: CGRectMake(0,0, kScreenWidth, IMAGE_HEIGHT))
            img.backgroundColor = UIColor.lightGrayColor()
            let defaultImg = UIImage(named: "temp_5")

            img.setImageWithURL(NSURL(string: self.mpOrder!.shopLogo)!, placeholderImage: defaultImg)

            let width = CGFloat(kScreenWidth - cellLeftMargin * 2)
            let titleInitX = IMAGE_HEIGHT + 10
            
            let labelTitle = self.baseLabel(CGRectMake(cellLeftMargin,titleInitX,width,self.titleHeight()))
            labelTitle.textColor = UIColor.msCommonColor()
            labelTitle.text = self.mpOrder?.title
            
            let descInitX = titleInitX + self.titleHeight() + 5
            let labelDesc = self.baseLabel(CGRectMake(cellLeftMargin,descInitX,width,self.descHeight()+10))
            labelDesc.text = self.mpOrder?.orderDesc
            
            cell?.contentView .addSubview(img)
            cell?.contentView .addSubview(labelTitle)
            cell?.contentView.addSubview(labelDesc)
            
        }else if section == priceSection{
            //价格 +  标签
            let label = self.baseLabel(CGRectMake(cellLeftMargin,0,kScreenWidth,44))
            label.textColor = UIColor.orangeColor()
            label.text = "￥" + self.mpOrder!.price
            cell?.contentView .addSubview(label)
            
            cell?.contentView .addSubview(self.styleView())
        }else if section == timeSection{
            //时间
            if row == 0{
                let startStr = self.mpOrder?.timeStart .timeStrWithFormat("MM-dd HH:mm")
                let endStr = self.mpOrder?.timeEnd.timeStrWithFormat("MM-dd HH:mm")
                cell?.textLabel?.text = "演出时间"
                cell?.detailTextLabel?.text = startStr! + " ~ " + endStr!
            }else if row == 1{
                cell?.textLabel?.text =  "报名截止时间"
                cell?.detailTextLabel?.text = self.mpOrder!.deadline.timeStrWithFormat()
            }
        }else if section == shopSection{
            if row == 0 {
                if self.mpOrder!.address != nil{
                    cell?.textLabel?.text = self.mpOrder?.address?.addressName
                }else{
                    cell?.textLabel?.text = self.mpOrder?.shopName
                }
            }else if row == 1 {
                if ((self.mpOrder!.address?.addressDetail.isEmpty) != nil){
                    cell?.textLabel?.text = self.mpOrder?.address?.addressDetail
                }else{
                    cell?.textLabel?.text = ""
                }
                cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            }
            
        }else if section == musicianSection{
            cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            
            if row == 0 {
                cell?.textLabel?.text = "已报名人数"
                cell?.detailTextLabel?.text = String(self.mpOrder!.signUpCount) + "人"
            }else if row == 1 {
                cell?.textLabel?.text = "已选乐手"
                cell?.detailTextLabel?.text = self.mpOrder!.singerInfo.userName
            }
        }
        
        return cell!
    }
    
    ///
    /// UITableViewDelegate
    ///
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == titleSection {
            return kScreenWidth * 0.8 + self.titleHeight() + self.descHeight() + 25
        }else{
            return 44
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView .deselectRowAtIndexPath(indexPath, animated:true )
        
        let section = indexPath.section
        let row = indexPath.row
        
        if self.mpOrder == nil {
            return
        }
        
        if section == titleSection {
        }else if section == priceSection{
        }else if section == timeSection{
        }else if section == shopSection{
        }else{
            if row == 0 {
                let subVC = MpSignedMusicianListViewController()
                subVC.orderData = self.mpOrder
                self.hidePushViewController(subVC, animated: true)
            }else if row == 1{
                
            }
        }

    }
    
    //loadmore delegate
    func pullTableViewDidTriggerLoadMore(pullTableView: PullTableView!) {
        
    }
    func pullTableViewDidTriggerRefresh(pullTableView: PullTableView!) {
        
        self.requestForOrderDetail()
    }
    
    
    
    /**
     *  internet
     */
    
    func requestForOrderDetail(){
        if self.mpOrder == nil{
            return
        }
        let request = MsRequestModel.requestForShopOrderDetail(self.mpOrder!.orderId,timeId: self.mpOrder!.timeId)
        
        netWorkMgr.post(request) { (status, result) -> Void in
            if status == "ok"{
                if result != nil{
                    let playBoard = (result!["payload"] as? NSDictionary)!
                    self.mpOrder = NormOrderModel(orderData: playBoard)
                    self.tableView.reloadData()
                    
                    self.tableView.pullTableIsRefreshing = false
                }
            }
        }
        
    }
    
    
    
    
}
