//
//  MsGoodsListViewController.swift
//  MusicShare
//
//  Created by poleness on 16/1/16.
//  Copyright © 2016年 poleness. All rights reserved.
//

import UIKit

class MsGoodsListViewController: MsBaseViewController {
    
    var collectionView:MsGoodsListCollectionView?
    
    var navTitle:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        
        self.requestForGoodsList()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initView(){
        self .setNavigationTitle(self.navTitle)
        self .setLeftBackImageWithWhite()
        self.view.backgroundColor = UIColor.msBackGroundColor()
        
        self.collectionView = MsGoodsListCollectionView(frame: self.view.frame)
        self.collectionView?.backgroundColor = UIColor.clearColor()
        
        self.view .addSubview(self.collectionView!)
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
    *  Action
    */
    
    
    /**
    *  Requsest
    */
    
    func requestForGoodsList(){
        
        self.collectionView!.collectionView.reloadData()
    }

}
