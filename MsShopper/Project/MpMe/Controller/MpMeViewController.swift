//
//  MpHomeViewController.swift
//  MusicShare
//
//  Created by poleness on 16/1/19.
//  Copyright © 2016年 poleness. All rights reserved.
//

import UIKit
import SVProgressHUD

class MpMeViewController: MsBaseViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    
    
    let tag_shop_store = 5
    let tag_shop_setting = 7
    let tag_shop_service = 8
    
    //UI
    var userView:UIView?
    var userImage:UIImageView?
    var userLabel:UILabel?
    var collectionView :UICollectionView?
    
    
    var identifier = "MpMeViewControllerCollection"
    var menuDataArr = NSArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        self.initData()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self .setNavigationTransparent(true)
        self.refreshView()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.hidesBottomBarWhenPushed = false
        self.setNavigationTransparent(false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initView(){
        self .initUserView()
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectFrame = CGRectMake(0, 64+88, kScreenWidth, kScreenHeight)
        self.collectionView = UICollectionView(frame: collectFrame, collectionViewLayout: layout)
        self.collectionView!.delegate = self
        self.collectionView!.dataSource = self
        self.collectionView?.alwaysBounceVertical = true //垂直滚动
        
        self.collectionView! .registerNib(UINib(nibName: "MpMeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: identifier)
        
        self.view.addSubview(self.collectionView!)
        
        self.collectionView!.backgroundColor = UIColor.clearColor()
        
    }
    
    func initData(){
        self.menuDataArr = ["演出招聘","驻场订单","演出活动","每日统计",
                            "我的账单","我的乐小店","待定","设置","联系客服"]
    }
    
    func initUserView(){
        self.userView = UIView(frame: CGRectMake(0,0,kScreenWidth,88+64))
        self.userView?.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.7)
        
        self.userImage = UIImageView(frame: CGRectMake(15,64 + 88/2-45/2, 45, 45))
        self.userImage?.layer.borderColor = UIColor.whiteColor().CGColor
        self.userImage?.layer.borderWidth = 1
        self.userImage?.image = UIImage(named: "temp_2")
        
        self.userLabel = UILabel(frame: CGRectMake(80,64 + 88/2-20/2,kScreenWidth - 60-30,20))
        self.userLabel?.font = UIFont.systemFontOfSize(15)
        self.userLabel?.textColor = UIColor.whiteColor()
            
        self.userView! .addSubview(self.userImage!)
        self.userView! .addSubview(self.userLabel!)
        
        let ges = UITapGestureRecognizer(target: self, action: Selector("loginAction"))
        self.userView!.addGestureRecognizer(ges)
        
        self.view .addSubview(self.userView!)
    }
    
    func refreshView(){
        if userMgr.isLogin() == true{
            self.userLabel?.text = userMgr.userInfo.nickName
        }else{
            self.userLabel?.text = "尚未登陆"
        }
        self.collectionView!.reloadData()
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    //collectoin
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        return CGSizeMake(kScreenWidth / 3, meCollectionCellHeight)
        
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 9
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! MpMeCollectionViewCell
        
        //        let contentSize = self.collectionView?.contentSize
        //        if(didAddSperateVerticalLine == NO) {
        //            UIView *verticalLine = [[UIView alloc]initWithFrame:CGRectMake(contentSize.width * 0.5 - 0.5, 0, 1, contentSize.height - 8)];
        //            verticalLine.backgroundColor = [UIColor lightGrayColor];//colorWithRed:225/225.0f green:227/225.0f blue:233/225.0f alpha:1.0];
        //            verticalLine.alpha = 0.35;
        //            [self.clevVideo addSubview:verticalLine];
        //            didAddSperateVerticalLine = YES;
        //        }
        //        let initY:CGFloat = CGFloat((20 + cell.frame.size.height)) * CGFloat(indexPath.row)
        //        let horizontalLine = UIView(frame: CGRectMake(0,initY , contentSize!.width, 1))
        //            horizontalLine.backgroundColor = UIColor.lightGrayColor()
        //        self.collectionView!.addSubview(horizontalLine)
        let name = NSString(format: "temp_%d", indexPath.row+1)
        cell.image.image = UIImage(named: name as String )
        
        if indexPath.row < 9 {
            cell.titleLabel.text = self.menuDataArr[indexPath.row] as? String
        }
        
        return cell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int{
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == OrderType.normal{
            let subVC = MpMyNormalOrderViewController()
            self.hidePushViewController(subVC, animated: true)
            
        }else if indexPath.row == OrderType.resident{
            let subVC = MpMyResidentViewController()
            self.hidePushViewController(subVC, animated: true)

        }else if indexPath.row == OrderType.show{
            let subVC = MpMyShowViewController()
            self.hidePushViewController(subVC, animated: true)

        }else if indexPath.row == tag_shop_store{
            let subVC = MsMyMusicStoreViewController()
            self .hidePushViewController(subVC, animated: true)
        
        }else if indexPath.row == tag_shop_setting{
            let subVC = MsSettingViewController()
            self .hidePushViewController(subVC, animated: true)
        
        }else if indexPath.row == tag_shop_service{
            SVProgressHUD .showInfoWithStatus("客服妹妹休息了，请明天再来吧")
        }
    }
    
    /**
    *  login
    */
    func loginAction(){
        if userMgr.isLogin() == false{
        let subVC = MpLoginViewController()
        subVC.viewSource = ShopLoginSource.FromPush
        self.hidePushViewController(subVC, animated: true)
        }
    }
}
