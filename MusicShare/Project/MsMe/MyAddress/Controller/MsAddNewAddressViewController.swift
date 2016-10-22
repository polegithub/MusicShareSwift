//
//  MsAddNewAddressViewController.swift
//  MusicShare
//
//  Created by poleness on 16/1/3.
//  Copyright © 2016年 poleness. All rights reserved.
//

import UIKit
import SVProgressHUD

class MsAddNewAddressViewController: MsBaseViewController,MsGeoSearchViewDelegate {
    
    //店铺名
    @IBOutlet weak var shopNameLabel: UILabel!
    
    //地址
    @IBOutlet weak var addressTxt: UITextField!
    
    //联系人
    @IBOutlet weak var contactTxt: UITextField!
    
    //手机号 + 备用
    @IBOutlet weak var phoneTxt: UITextField!
    @IBOutlet weak var reservePhoneTxt: UITextField!
    
    //data
    var addressModel:MsAddressModel! = MsAddressModel()
    
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
    
    func initView(){
        self .setLeftBackImageWithWhite()
        
        self.setNavigationTitle("新建地址")
        
        let barButton = UIBarButtonItem(title: "保存", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("saveAddress"))
        self.navigationItem.rightBarButtonItem = barButton
        
    }
    
    func initData(){
        
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
    //点击修改店铺名
    @IBAction func editShopNameAction(sender: AnyObject) {
        
        let subVC = MsGeoSearchViewController()
        subVC.delegate = self
        self .hidePushViewController(subVC, animated: true)
    }
    
    
    //点击保存
    func saveAddress(){
        if self.isInputValid() == false {
            return
        }
        
        self.addressModel.lat = "121.1312312"
        self.addressModel.lng = "30.3123123"
        self.addressModel.cityCode = "021"
        
        let array_M = NSMutableArray()
        if self.phoneTxt.text!.isEmpty == false {
            array_M .addObject(self.phoneTxt.text!)
        }
        
        if self.reservePhoneTxt.text != nil && self.reservePhoneTxt.text!.isEmpty == false {array_M .addObject(self.reservePhoneTxt.text!)
            
        }
        self.addressModel.addressPhone = array_M
        
        
        self.requestForSaveNewAddress()
    }
    
    
    /**
     *  Input check
     */
    func isInputValid()->Bool{
        if self.shopNameLabel.text!.isEmpty{
            SVProgressHUD .showInfoWithStatus("请输入店铺名称")
            return false
        }
        
        if self.addressTxt.text! .isEmpty{
            SVProgressHUD .showInfoWithStatus("请输入地址")
            return false
        }
        
        if self.contactTxt.text! .isEmpty{
            SVProgressHUD .showInfoWithStatus("请输入联系人")
            return false
        }
        
        if self.phoneTxt.text!.isEmpty{
            SVProgressHUD .showInfoWithStatus("请输入联系方式")
            return false
        }
        
        return true
    }
    
    
    
    /**
     *  Network
     */
    func requestForSaveNewAddress(){
        
        let request = MsRequestModel .requestForAddressNew(self.addressModel.lat!, longitude: self.addressModel.lng!, name: self.shopNameLabel.text!, address: self.addressTxt.text!, detailAddress: "", cityCode: self.addressModel.cityCode!, contact: self.contactTxt.text!, phoneArray: self.addressModel.addressPhone!)
        
        netWorkMgr.post(request) { (status, result) -> Void in
            if status == "ok"{
                SVProgressHUD .showInfoWithStatus("添加成功")
                self.goBack()
            }
            
        }
    }
    
    
    /**
     *  geo delegate
     */
    func didConfirmedAddress(address:AMapPOI){
        self.shopNameLabel.text = address.name
        self.addressTxt.text = address.address
        
    }
    
    
}
