//
//  MsGoodsViewController.swift
//  MusicShare
//
//  Created by poleness on 15/12/6.
//  Copyright © 2015年 poleness. All rights reserved.
//

import UIKit

//let GoodsPrice = 0
let GoodsInfo = 0
let GoodsDesc = 1
let GoodsMusician = 2
let GoodsAppr = 3


protocol ParamsProtocol{
    //协议中得方法不能有结构体
    func returnParams(tmpStr: String)
}

class MsGoodsMainViewController: MsBaseViewController ,UITableViewDelegate,UITableViewDataSource{

    var apprArray = NSMutableArray()
    var dataArray = NSMutableArray()
    
    var paramsProtocolDelegate: ParamsProtocol?
    
    var navTitle:NSString = ""
    var navAlpha:CGFloat = 0.0
    
    //UI
    
    @IBOutlet weak var tableView: UITableView!
    var headImgView:UIImageView?
    
    //购买btn
    @IBOutlet weak var buyBtn: UIButton!
    //价格
    @IBOutlet weak var goodsFeeLabel: UILabel!
    //优惠
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge.Top
        self .setNavigationTransparent(true)
        
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
        
        self.setNavigationDefaultImage()
        self.setNavBacgroundWithAlpha(self.navAlpha)
        
        self.tableView?.delegate = self

    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tableView?.delegate = nil //in case of crash
        
        self .setNavigationTransparent(false)
        self.setNavBacgroundWithAlpha(1.0)
        
    }
    
    func initView(){
        
        self .setLeftBackImageWithWhite()
        
        self.headImgView = UIImageView(frame: CGRectMake(0, 0, kScreenWidth, 300))
        self.headImgView!.image = UIImage(named: "temp_8")
        self.tableView?.tableHeaderView = self.headImgView
        
        //去掉导航栏的底部line
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        //底部购物
        self.buyBtn.layer.cornerRadius = 4.0
        self.buyBtn.backgroundColor = UIColor.msCommonColor()
        
        self.goodsFeeLabel.textColor = UIColor.msCommonColor()
 
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
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1;
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if  GoodsAppr == section {
            return self.apprArray.count

        }else{
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifierNormal = "MsHomeViewControllerCellNormal"
        let cellIdentifierCustomer = "MsHomeViewControllerCellCustomer"
        
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifierNormal)
        
        var cellCustomer:MsGoodsAppraisalCell?
        
        if indexPath.section == GoodsAppr {
            if cellCustomer == nil {
                tableView .registerNib(UINib(nibName: "MsGoodsAppraisalCell", bundle: nil), forCellReuseIdentifier: cellIdentifierCustomer)
            
                cellCustomer = tableView.dequeueReusableCellWithIdentifier(cellIdentifierCustomer) as? MsGoodsAppraisalCell
            }
        }else{
            if  cell == nil {
                cell = UITableViewCell(style:UITableViewCellStyle.Subtitle, reuseIdentifier:cellIdentifierNormal)
            }
        }
        
        let section = indexPath.section
        let row = indexPath.row
        
        if  (cell != nil)  {
            cell!.backgroundColor = UIColor .whiteColor()
            cell?.contentView .removeAllSubviews()
            cell?.imageView?.image = nil
            
            cell?.textLabel?.numberOfLines = 0
            cell?.textLabel?.font = UIFont.systemFontOfSize(15.0)
        }
        
        switch(section){
//        case GoodsPrice:
//            
//            cell?.textLabel?.text = "￥1.0"
//            
//            break
            
        case GoodsInfo:
            
            cell?.textLabel?.text = "扎西德勒"
            
            break
        case GoodsDesc:
            
            cell?.textLabel?.text = "雷鬼乐和更多具有浓郁地域色彩的乐器的融入，标志着痛仰乐队在创作上又进入了崭新的阶段"
            
            break
        case GoodsAppr:
            
            let temp = NSString(format: "temp_%d", arc4random_uniform(12) + 1)
            cellCustomer?.userPhoto.image = UIImage(named: temp as String)
            cellCustomer?.userComment.text = self.apprArray.objectAtIndex(row) as? String
            
            if row % 2 == 0 {
                cellCustomer?.userName.text = "张**议"
            }else{
                cellCustomer?.userName.text = "Speai**one"
            }
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd"
            // Date 转 String
            let nowString = dateFormatter.stringFromDate(NSDate())
            cellCustomer?.commentTime.text = nowString
            
            break
        case GoodsMusician:
            let imageView = UIImageView(frame: CGRectMake(kScreenWidth/2 - 50/2, 20, 50, 50))
            imageView.image = UIImage(named: "temp_6")
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 25.0
            
            let label = UILabel(frame: CGRectMake(kScreenWidth/2 - 100/2 ,70,100,20))
            label.text = "痛仰乐队"
            label.font = UIFont.systemFontOfSize(13)
            label.textColor = UIColor.lightGrayColor()
            label.textAlignment = NSTextAlignment.Center
            
            cell?.contentView .addSubview(imageView)
            cell?.contentView .addSubview(label)
            
            break
            
        default:
            break
        }

        
        if cell == nil {
            return cellCustomer!
        }else{
            return cell!            
        }
    }
    
    ///
    /// UITableViewDelegate
    ///
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height:CGFloat  = 0.0
        switch(indexPath.section){
//        case GoodsPrice:
//            height = 44
//            break
        case GoodsInfo:
            height = 66
            break
        case GoodsDesc:
            height = 88
            break
        case GoodsAppr:
            height = 88
            break
        case GoodsMusician:
            height = 100
            break
        default:
            height = 44
            break
        }
        return height
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView .deselectRowAtIndexPath(indexPath, animated:true )
 
    }
    
    //MARK : UIScrollview delegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        NSLog("chenglong %f", scrollView.contentOffset.y)
        //调整导航栏的颜色
        if (scrollView.contentOffset.y > 0) {
            var offset = fabs(scrollView.contentOffset.y);
            if (offset > 64) {
                offset = 64;
            }
            self.navAlpha = offset / 64; //因为是反的，所以1-
            
        } else {
            self.navAlpha = 0;
        }
        
        self.updateNagivationBackground()
    }
    
    
    // MARK: searchbardelegae
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        let searchVC = MsSearchMainViewController()
        self .hidePushViewController(searchVC, animated: true)
        
        return false
    }
    
    
    //Mark : Action
    
    //购买ACTION
    @IBAction func buyAction(sender: AnyObject) {
        let subVC = MsOrderPayViewController()
        self .hidePushViewController(subVC, animated: true)
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
