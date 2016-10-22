//
//  MpMyNormalOrderViewController.swift
//  MusicShare
//
//  Created by poleness on 16/2/23.
//  Copyright © 2016年 poleness. All rights reserved.
//

import UIKit

class MpMyNormalOrderViewController: MsBaseViewController,MpNormalOrderListViewDelegate {

    var normalOrderView:MpNormalOrderListTableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        
        self.setLeftBackImageWithWhite()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self .setNavigationShopperImage()
    }
    
    func initView(){
        self .setNavigationTitle("演出招聘")
        self.view.backgroundColor = UIColor.msBackGroundColor()
        
        self.normalOrderView = MpNormalOrderListTableView(frame: CGRectMake(0,0,kScreenWidth,kScreenHeight - 60 - 64))
        self.normalOrderView?.delegate = self
        self.view .addSubview(self.normalOrderView!)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func refreshNormalOrderList(state:Int,isLoadMore:Bool){
        
    }
    
    func didSelectNormalOrder(order:NormOrderModel){
        
    }



}
