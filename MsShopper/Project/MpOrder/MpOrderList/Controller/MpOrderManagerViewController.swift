//
//  MpOrderManagerViewController.swift
//  MusicShare
//
//  Created by poleness on 16/1/21.
//  Copyright © 2016年 poleness. All rights reserved.
//

import UIKit
import SVProgressHUD

class MpOrderManagerViewController: MsBaseViewController ,UICollectionViewDataSource,UICollectionViewDelegate {

    
    
    let tag_scan = 0
    let tag_order = 1
    let tag_resident = 2
    let tag_show = 3
    
    //UI
    let topViewHeight:CGFloat = 88 + 64
    
    var userView:UIView?
    var userImage:UIImageView?
    var userLabel:UILabel?
    var collectionView :UICollectionView?
    
    
    var identifier = "MpOrderManagerViewConllection"
    
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
        self.collectionView!.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.setNavigationTransparent(false)
        self.hidesBottomBarWhenPushed = false

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initView(){
        self.edgesForExtendedLayout = UIRectEdge.None
        
        //        self .setNavigationTitle("我的")
        
        self .initUserView()
        
        let layout = UICollectionViewFlowLayout()
        //        layout.sectionInset = UIEdgeInsetsMake(10, 0, 0, 0)
        //        layout.itemSize = CGSizeMake(kScreenWidth/5, 100)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectFrame = CGRectMake(0, 64+88 + 20, kScreenWidth, kScreenHeight)
        self.collectionView = UICollectionView(frame: collectFrame, collectionViewLayout: layout)
        self.collectionView!.delegate = self
        self.collectionView!.dataSource = self
        self.collectionView?.scrollEnabled = false
        
        self.collectionView! .registerNib(UINib(nibName: "MpMeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: identifier)
        
        self.view.addSubview(self.collectionView!)
        
        self.collectionView!.backgroundColor = UIColor.clearColor()
        
    }
    
    func initData(){
        self.menuDataArr = ["我的订单","驻店订单","待确认","待评价","历史演出","我的账单","每日统计","敬请期待"]
    }
    
    
    func initUserView(){
        
        let array = ["扫一扫","普通演出","长期驻唱","演出公告"]
        self.userView = UIView(frame: CGRectMake(0,0,kScreenWidth,topViewHeight))
        self.userView?.backgroundColor = UIColor.msCommonColor().colorWithAlphaComponent(0.8)

        
        for index in 0...3 {
            let initX :CGFloat = CGFloat(kScreenWidth / 4) * CGFloat(index)
            let button = UIButton(frame: CGRectMake(initX,64,kScreenWidth/4,64))
//            button.backgroundColor = UIColor.redColor()
            button.tag = index
            button .addTarget(self, action: Selector("navButtonAction:"), forControlEvents: UIControlEvents.TouchUpInside)
            
            let leftMargin:CGFloat = kScreenWidth / 4 / 2 - 45 / 2
            let image = UIImageView(frame: CGRectMake(initX + leftMargin, 64+88/2-45, 45, 45))
            image.image = UIImage(named: "temp_2")
            image.backgroundColor = UIColor.orangeColor()
            
            
            let title = UILabel(frame: CGRectMake(initX,image.origin().y+image.height()+5,kScreenWidth/4,20))
            title.font = UIFont.systemFontOfSize(15)
            title.textAlignment = NSTextAlignment.Center
            title.textColor = UIColor.blackColor()
            title.text = array[index] as String
            
            self.userView! .addSubview(title)
            self.userView!.addSubview(image)
            self.userView! .addSubview(button)
        }
        
//
//        self.userImage = UIImageView(frame: CGRectMake(15,64 + 88/2-45/2, 45, 45))
//        self.userImage?.layer.borderColor = UIColor.whiteColor().CGColor
//        self.userImage?.layer.borderWidth = 1
//        self.userImage?.image = UIImage(named: "temp_2")
//        
//        self.userLabel = UILabel(frame: CGRectMake(80,64 + 88/2-20/2,kScreenWidth - 60-30,20))
//        self.userLabel?.text = "用户xxx"
//        self.userLabel?.font = UIFont.systemFontOfSize(15)
//        self.userLabel?.textColor = UIColor.whiteColor()
        
//        self.userView! .addSubview(self.userImage!)
//        self.userView! .addSubview(self.userLabel!)
        
        self.view .addSubview(self.userView!)
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
     * Action
     */
    func navButtonAction(button:UIButton){
        switch(button.tag){
        case tag_scan:
            SVProgressHUD .showInfoWithStatus("敬请期待...")
            break
        case tag_order:
//            let subVC = MpCreatePerormOrderViewController()
//            self .hidePushViewController(subVC, animated: true)
            break
            
        case tag_resident:
            break
            
        case tag_show:
            let subVC = MpCreatePerformViewController()
            self.hidePushViewController(subVC, animated: true)
            break
            
        default:
            break
        }
        
        
        

    }
    
    //collectoin
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        return CGSizeMake(kScreenWidth/4, meCollectionCellHeight)
        
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 8
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
        
        cell.imageWidthLayout.constant = 36
        cell.imageHeightLayout.constant = 36
        
        cell.image.layer.cornerRadius = 18
        cell.image.clipsToBounds = true
        
        if indexPath.row < 8 {
            cell.titleLabel.text = self.menuDataArr[indexPath.row] as? String
        }
        
        return cell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int{
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        let subVC = MpOrderAndShowMainViewController()
        self .hidePushViewController(subVC, animated: true)
    }

}
