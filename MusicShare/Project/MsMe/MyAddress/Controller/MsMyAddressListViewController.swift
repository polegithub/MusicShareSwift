//
//  MsMyAddressListViewController.swift
//  MusicShare
//
//  Created by poleness on 16/1/2.
//  Copyright © 2016年 poleness. All rights reserved.
//

import UIKit
import SVProgressHUD


protocol MsMyAddressListDelegate{
    func didSelectAddress(address:MsAddressModel)
}

class MsMyAddressListViewController: MsBaseViewController,UITableViewDataSource,UITableViewDelegate{
    
    //data
    var delegate:MsMyAddressListDelegate?
    
    var dataSource = NSMutableArray()
    
    //当前选择的address id
    var currentAddrId:String?
    
    var tableView: UITableView!
    let cellIdentifier = "MsMyAddressListViewControllerCell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
        self.initData()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.requestForAddressData(false)
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    func initData(){
        self.requestForAddressData()
    }
    
    func initView(){
        self.view.backgroundColor = UIColor.msBackGroundColor()
        
        
        self.tableView = UITableView(frame: CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64), style :.Grouped)
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        self.tableView.backgroundColor = UIColor.clearColor()
        
        self.tableView? .registerNib(UINib(nibName: "MsAddressListTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.view .addSubview(self.tableView!)
        
        self .setNavigationTitle("我的地址")
        self .setLeftBackImageWithWhite()
        
        let right  = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: Selector("addNewAddress"))
        self.navigationItem.rightBarButtonItem = right
        
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
    /// UITableViewDataSource
    ///
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.dataSource.count
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! MsAddressListTableViewCell
        
        cell.backgroundColor = UIColor.whiteColor()
        
        let address = self.dataSource .objectAtIndex(indexPath.section) as! MsAddressModel
        
        if address.addressId == self.currentAddrId {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }else{
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        
        
        if address.addressName.isEmpty {
            cell.addressName.text = "暂无"
            cell.nameHeightLayout.constant = 20.0
        }else{
            cell.addressName.text = address.addressName
            cell.nameHeightLayout.constant = self.heightForCellName(indexPath.section)
        }
        
        //map 需要保持和detail 居中对齐;20 home_icon的高度， 3 是默认的toplayout
        let detailHeight = self.heightForCellDetail(indexPath.section)
        cell.mapTopLayout.constant = cell.nameHeightLayout.constant - 20.0 + 3.0 + detailHeight / 2 - 20 / 2
        
        
        if address.addressDetail.isEmpty {
            cell.addressLocation.text = "暂无"
        }else{
            cell.addressLocation.text = address.addressDetail
        }
        
        if address.addressContact.isEmpty{
            cell.contact.text = "暂无"
        }else{
            cell.contact.text = address.addressContact
        }
        
        if address.addressPhone != nil {
            cell.addressPhone.text = self.getPhoneStrFromArray(address.addressPhone!)
        }else{
            cell.addressPhone.text = "暂无"
        }
        
        
        return cell
    }
    
    func getPhoneStrFromArray(array:NSArray)->String{
        if array.count > 0 {
            var phoneStr:String = ""
            for var i = 0;i < array.count;i++ {
                if i == 0 {
                    phoneStr = array .objectAtIndex(i) as! String
                }else{
                    phoneStr = phoneStr + "," + (array.objectAtIndex(i) as! String)
                }
            }
            
            return phoneStr
        }
        return ""
    }
    
    ///
    /// UITableViewDelegate
    ///
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let height = self.heightForCellDetail(indexPath.section) + self.heightForCellName(indexPath.section)
        return  65 + height
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView .deselectRowAtIndexPath(indexPath, animated:true )
        let address = self.dataSource .objectAtIndex(indexPath.section) as! MsAddressModel
        
        self.delegate? .didSelectAddress(address)
        
        self .goBack()
        
    }
    
    //cell height
    func heightForCellName(index:Int)->CGFloat{
        let address = self.dataSource .objectAtIndex(index) as! MsAddressModel
        let height = address.addressName .textSize(15.0, maxWidth: kScreenWidth - 33.0 - 15.0, maxHeight: CGSizeZero.width).height
        if height > 20 {
            return height
        }else{
            return 20
        }
    }
    
    func heightForCellDetail(index:Int)->CGFloat{
        let address = self.dataSource .objectAtIndex(index) as! MsAddressModel
        let height = address.addressDetail! .textSize(14.0, maxWidth: kScreenWidth - 33.0 - 15.0, maxHeight: CGSizeZero.width).height
        if height > 20 {
            return height
        }else{
            return 20
        }
    }
    
    
    /**
     * Action
     */
    func addNewAddress(){
        let subVC = MsAddNewAddressViewController()
        self .hidePushViewController(subVC, animated:true)
    }
    
    /**
     *  Network
     */
    
    func requestForAddressData(animation:Bool = true){
        
        let request = MsRequestModel.requestForAddressList()
        if animation{
        SVProgressHUD .showInfoWithStatus("请稍候...", maskType: SVProgressHUDMaskType.None)
        }
        netWorkMgr.post(request) { (status, result) -> Void in
            if status == "ok" {
                if animation{
                    SVProgressHUD .dismiss()
                }
                let content:NSArray = (result!["payload"] as? NSArray)!
                self.dataSource .removeAllObjects()
                for dic in content {
                    let address = MsAddressModel(listDic: dic as! NSDictionary)
                    self.dataSource .addObject(address)
                }
            }
            
        self.tableView .reloadData()
    }
        
    }
    
}
