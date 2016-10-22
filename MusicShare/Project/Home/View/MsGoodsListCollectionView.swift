//
//  MsGoodsListCollectionView.swift
//  MusicShare
//
//  Created by poleness on 16/1/16.
//  Copyright © 2016年 poleness. All rights reserved.
//

import UIKit

class MsGoodsListCollectionView: UIView ,UICollectionViewDataSource,UICollectionViewDelegate{

    
    var collectionView:UICollectionView!
    
    //data
    var dataSource = NSArray()
    
    var identifier = "GoodsListCollectionCell"
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        self .initCollectionView()
    }
    
//    override init() {
//        super.init()
//        self.initCollectionView()
//    }
    
    required init?(coder aDecoder: NSCoder) {
        //        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
    func initCollectionView(){
//        self.collectionView .registerClass(NSClassFromString("MsGoodsCollectionViewCell") , forCellWithReuseIdentifier: identifier)
//       
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(1, 1, 1, 1)
        layout.itemSize = CGSizeMake(kScreenWidth/2 - 2.0, 140)
        
        self.collectionView = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView .registerNib(UINib(nibName: "MsGoodsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: identifier)
        
        self .addSubview(self.collectionView)
        
        self.collectionView.backgroundColor = UIColor.clearColor()
        self.backgroundColor = UIColor.redColor()
        
    }

    //更新
    
    
    //collectoin 
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 2
    }
     func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! MsGoodsCollectionViewCell
//        cell.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        
//        let count = self.dataSource.count
//        let section = indexPath.section
//        let index = section >= count ? section - count : section

        
        return cell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int{
        return 10
    }


}
