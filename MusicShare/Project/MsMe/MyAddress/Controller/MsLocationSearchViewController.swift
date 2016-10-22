//
//  MsLocationSearchViewController.swift
//  MusicShare
//
//  Created by poleness on 16/2/23.
//  Copyright © 2016年 poleness. All rights reserved.
//

import UIKit

protocol MsLocationSearchViewDelegate{
    func userUpdatedLocation(locationText:String)
}

class MsLocationSearchViewController: MsBaseViewController,UITableViewDataSource,UITableViewDelegate {
    
    var deledate:MsLocationSearchViewDelegate?
    
    //UI
    var tableView:UITableView!
    
    //data
    var historyArray = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initView(){
        self.setLeftBackImageWithWhite()
        
        
        self.tableView = UITableView(frame: CGRectMake(0, 0, kScreenWidth, kScreenHeight), style: UITableViewStyle.Grouped)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.view .addSubview(self.tableView)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0.0
        }
        return 30
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        //chenglong
        return 2
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else{
            return self.historyArray.count
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "MsLocationSearchViewControllerCell"

        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        
        if cell == nil{
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: cellIdentifier)
        }
        
        cell!.backgroundColor = UIColor .whiteColor()
        
        //        let showModel  = self.dataArray .objectAtIndex(indexPath.section) as? NormOrderModel
        
        if indexPath.row == 0 {
            cell?.textLabel?.text = "定位当前位置"
        }else{
            
        }
        
        return cell!
    }
    
    ///
    /// UITableViewDelegate
    ///
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView .deselectRowAtIndexPath(indexPath, animated:true )
        
        //        self.delegate? .didSelectOrder(MsOrderModel())
        if indexPath.row == 0{
            userLocateMgr.startLocationAction()
        }
    }
    
    


}
