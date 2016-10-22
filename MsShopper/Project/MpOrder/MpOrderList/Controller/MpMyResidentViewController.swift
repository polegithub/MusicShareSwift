//
//  MpMyResidentViewController.swift
//  MusicShare
//
//  Created by poleness on 16/2/23.
//  Copyright © 2016年 poleness. All rights reserved.
//

import UIKit

class MpMyResidentViewController: MsBaseViewController,MpResidentOrderListViewDelegate {

    
    var residentOrderView:MpResidentOrderListTableView?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self .setNavigationShopperImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initView(){
        self.setLeftBackImageWithWhite()
        
        self.view.backgroundColor = UIColor.msBackGroundColor()
        
        self.residentOrderView = MpResidentOrderListTableView(frame:CGRectMake(0,0,kScreenWidth,kScreenHeight - 60 - 64))
        self.residentOrderView?.delegate = self
        self.view.addSubview(self.residentOrderView!)

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MpResidentOrderListViewDelegate
    func refreshResidentOrderList(){
        
    }
    func loadModeResidentOrderList(){
        
    }

}
