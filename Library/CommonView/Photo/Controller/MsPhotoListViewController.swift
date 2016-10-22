//
//  MsPhotoListViewController.swift
//  MusicShare
//
//  Created by poleness on 15/12/18.
//  Copyright © 2015年 poleness. All rights reserved.
//

import UIKit
import SVProgressHUD


class MsPhotoListViewController: MsBaseViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    
    //data
    var dataSource = NSArray()
    
    var collectionView: UICollectionView!
    //菜单需要动态时时调整
    var menuArray = NSMutableArray()
    
    let cellIdentifier = "MsPhotoListViewControllerCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.hidesBottomBarWhenPushed = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationTransparent(false)
        
        self.collectionView .reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initData(){
    }
    
    func initView(){
        
        self.setLeftBackImageWithWhite()
        self.view.backgroundColor = UIColor.msBackGroundColor()
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: kScreenWidth/2 - 20, height: 90)
        
        let frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView!.dataSource = self
        collectionView!.delegate = self
        collectionView!.registerNib(UINib(nibName: "MsPhotoListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        collectionView!.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(collectionView!)
        
        self.collectionView .reloadData()
        
        self .setNavigationTitle("照片")
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
    /// UICollectView
    ///
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 2
        
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! MsPhotoListCollectionViewCell
        cell.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        
        let count = self.dataSource.count
        let section = indexPath.section
        let index = section >= count ? section - count : section
        cell.image?.image = self.dataSource .objectAtIndex(index) as? UIImage
        
        if section % 3 == 0 {
            cell.imageTitle?.text = "guita spam"
        }else if section == 1 {
            cell.imageTitle?.text = "my space"
        }else{
            cell.imageTitle?.text = "other name"
        }
        
        return cell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int{
        return self.dataSource.count * 2
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        SVProgressHUD .showInfoWithStatus("点击了图片")
    }
    /**
     Action
     */

    
    
    
    
    
    
    //网络请求
    func requestForUserInfo(){
        let isLogin:Bool = userMgr.isLogin()
        if isLogin == false {
            collectionView!.reloadData()
            return
        }
        
//        let request = MsRequestModel.requestForUserInfo()
//        netWorkMgr.get(request) { (status, result) -> Void in
//            
//            
            self.collectionView.reloadData()
//        }
        
        
    }
    
    
}
