//
//  MpCreatePerformViewController.swift
//  MusicShare
//
//  Created by poleness on 15/12/14.
//  Copyright © 2015年 poleness. All rights reserved.
//

import UIKit
import SVProgressHUD
import ActionSheetPicker_3_0

let TAG_DATE_START = 1
let TAG_DATE_END = 2


class MpCreatePerformViewController: MsBaseViewController,UIActionSheetDelegate,UITextFieldDelegate,UITextViewDelegate,MsMyAddressListDelegate,UIImagePickerControllerDelegate{
    
    var datePick:UIDatePicker!
    
    @IBOutlet weak var scrollView:UIScrollView?
    @IBOutlet weak var inputBackView:UIView?
    
    @IBOutlet weak var titleTxt: UITextField!
    //标题
    //描述
    @IBOutlet weak var descTxt: UITextField!
    
    //日期
    @IBOutlet weak var dateBtnStart:UIButton!
    @IBOutlet weak var  dateBtnEnd:UIButton!
    
    @IBOutlet weak var dateStartTxt: UITextField!
    @IBOutlet weak var dateEndTxt: UITextField!
    
    
    //场地 + 位置
    @IBOutlet weak var shopNameLabel: UILabel!
    
    @IBOutlet weak var shopNameTopLayout: NSLayoutConstraint!
    @IBOutlet weak var shopAddressLabel: UILabel!
    
    
    //照片
    @IBOutlet weak  var photoView:UIView?
    @IBOutlet weak var photoBackView: UIView!
    
    var photoBottomView:UIView? //选择照片后底部的确认视图
    var imageChoose:UIImage?
    
    @IBOutlet weak var photoBackHeightLayout: NSLayoutConstraint!
    
    //DATA
    var currentAddress:MsAddressModel = MsAddressModel()
    var startTimerval:String! = ""
    var endTimerval:String! = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.scrollView?.contentSize = CGSizeMake(kScreenWidth, kScreenHeight + 64)
        
    }
    
    
    func initView(){
        //        self.setNavigationTitle("发布演出")
        self.setLeftBackImageWithWhite()
        self.view.backgroundColor = UIColor.msBackGroundColor()
        
        
        self.datePick = UIDatePicker(frame: CGRectMake(0,kScreenHeight - 216,kScreenWidth,216))
        self.datePick?.backgroundColor = UIColor.whiteColor()
        self.datePick?.locale = NSLocale(localeIdentifier: "zh_CN")
        self.datePick?.datePickerMode = UIDatePickerMode.DateAndTime
        self.datePick?.addTarget(self, action: Selector("datePickValueChanged:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        self.scrollView?.backgroundColor = UIColor.clearColor()
        self.scrollView?.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
        
        
        self.refreshPhotoView()//添加照片的按钮
        
        if self.currentAddress.addressId.isEmpty {
            self.shopNameTopLayout.constant = 88 / 2  - 20 / 2
            self.shopNameLabel.text = "点击选择演出地址"
            self.shopNameLabel.textColor = UIColor.msPlaceholderColor()
            self.shopAddressLabel.text = ""
        }
        
        let right = UIBarButtonItem(title: "保存", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("saveAndPublishShow"))
        self.navigationItem.rightBarButtonItem = right
        
    }
    
    func refreshPhotoView(){
        
        self.photoView!.removeAllSubviews()
        
        let imgView = UIImageView(frame: CGRectMake(15,10,130,130))
//        imgView.layer.borderColor = UIColor.lightGrayColor().CGColor
//        imgView.layer.borderWidth = 1.0
        
        imgView.image = self.imageChoose
        imgView.contentMode = UIViewContentMode.ScaleAspectFit
        
        let button  = UIButton(frame: imgView.bounds)
        button .addTarget(self, action: Selector("addNewPhoto"), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.photoView!.addSubview(imgView)
        self.photoView!.addSubview(button)
        
    }
    
    func addNewPhoto(){
        let alertView = UIAlertController(title:nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let photoAction = UIAlertAction(title: "照片", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            self.showPhotoView(SysPhotoLibrary)
        }
        
        let cameraAction = UIAlertAction(title: "拍照", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            self.showPhotoView(SysCamera)
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        
        alertView.addAction(photoAction)
        alertView.addAction(cameraAction)
        alertView.addAction(cancelAction)
        
        self.presentViewController(alertView, animated: true, completion: nil)
        
    }
    
    func showPhotoView(type:Int){
        let phVC = UIImagePickerController()
        phVC.delegate = self
        if type == SysCamera{
            phVC.sourceType = UIImagePickerControllerSourceType.Camera
        }else{
            phVC.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        
        self.presentViewController(phVC, animated: true, completion: nil)
        
    }
    
    
    /**
     *Unit
     */
     
     
     
     // MARK: - Table view data source
     
     /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
     
     
     /**
     *  UI
     */
     
     
     //photo delegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        
        let img = info["UIImagePickerControllerOriginalImage"] as! UIImage
        self.imageChoose = img
        self .showChoosedPhotoView()
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController){

        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func showChoosedPhotoView(){
        
        self.updatePhotoBottomView()
        
//        [UIApplication sharedApplication].keyWindow]
        UIApplication.sharedApplication().keyWindow!.addSubview(self.photoBottomView!)
        
    }
    
    //初始化照片bottomview
    func updatePhotoBottomView(){
        self.photoBottomView = UIView(frame: UIScreen.mainScreen().bounds)
        self.photoBottomView?.backgroundColor = UIColor.blackColor()
        
        let scrollView = UIScrollView(frame:self.photoBottomView!.bounds)
        scrollView.contentSize = CGSizeMake(kScreenWidth + 64, kScreenHeight + 64)
        
        //基于照片的实际大小，按照宽度成比例调整高度
        let height = kScreenWidth * self.imageChoose!.size.height / self.imageChoose!.size.width
        let imgView = UIImageView(frame:CGRectMake(0,kScreenHeight/2 - height/2,kScreenWidth,height))
        imgView.image = self.imageChoose
        scrollView .addSubview(imgView)
        self.photoBottomView! .addSubview(scrollView)
        
        let backView = UIView(frame:CGRectMake(0,kScreenHeight - 50,kScreenWidth,50))
        backView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        
        let leftButton  = UIButton(frame: CGRectMake(15,50/2-44/2,80,44))
        leftButton .setTitle("取消", forState: UIControlState.Normal)
        leftButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        leftButton .addTarget(self, action: Selector("photoCancelAction"), forControlEvents: UIControlEvents.TouchUpInside)
        
        let rightButton = UIButton(frame: CGRectMake(kScreenWidth - 15 - 80,50/2-44/2,80,44))
        rightButton .setTitle("确认", forState: UIControlState.Normal)
        rightButton .addTarget(self, action: Selector("photoConfirmAction"), forControlEvents: UIControlEvents.TouchUpInside)
        rightButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        backView .addSubview(leftButton)
        backView.addSubview(rightButton)
        
        self.photoBottomView! .addSubview(backView)

    }
    
    func photoCancelAction(){
        self.photoBottomView! .removeFromSuperview()
    }
    
    func photoConfirmAction(){
        self.dismissViewControllerAnimated(true, completion: nil)
        self.photoBottomView! .removeFromSuperview()

        self.refreshPhotoView()
    }
    
     
     
     //PickViewDelegate
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 2
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return  10
    }
    
    //pickview监听时间
    func datePickValueChanged(pickView:UIDatePicker){
        
    }
    
    
    /**
     *  Action
     */
     //消失键盘
    func dismissKeyboard(){
        
        if self.dateStartTxt .isFirstResponder(){
            self.dateStartTxt .resignFirstResponder()
        }
        
        if self.dateEndTxt .isFirstResponder(){
            self.dateEndTxt .resignFirstResponder()
        }
        
        if self.titleTxt.isFirstResponder(){
            self.titleTxt.resignFirstResponder()
        }
        if self.descTxt.isFirstResponder(){
            self.descTxt.resignFirstResponder()
        }
        
        
    }
    
    //点击编辑地址
    @IBAction func editLocationAction(sender: AnyObject) {
        let subVC = MsMyAddressListViewController()
        subVC.delegate = self
        subVC.currentAddrId = self.currentAddress.addressId
        self .hidePushViewController(subVC, animated: true)
    }
    
    func didSelectAddress(address: MsAddressModel) {
        
        self.currentAddress = address
        
        self.shopNameTopLayout.constant = 15.0
        self.shopNameLabel.textColor = UIColor.blackColor()
        
        self.shopNameLabel.text = address.addressName
        self.shopAddressLabel.text = address.addressDetail
        
    }
    
    //点击时间
    @IBAction func showTimePickAction(sender: AnyObject) {
        self.dismissKeyboard()
        let button = sender as! UIButton
        var title = "选择开始时间"
        if button.tag == TAG_DATE_END {
            title = "选择结束时间"
        }
        
        ActionSheetDatePicker .showPickerWithTitle(title, datePickerMode: UIDatePickerMode.DateAndTime, selectedDate: NSDate(), doneBlock: { (pick, date, origin) -> Void in
            
            let format = NSDateFormatter()
            format.dateFormat = "yy-MM-dd hh:mm"
            let dateStr = format.stringFromDate(date as! NSDate)
            if button.tag == TAG_DATE_START {
                self.dateStartTxt.text = dateStr
                self.startTimerval = String(date.timeIntervalSince1970)
            }else{
                self.dateEndTxt.text = dateStr
                self.endTimerval = String(date.timeIntervalSince1970)
            }
            
            }, cancelBlock: { (pick) -> Void in
                
            }, origin: self.view)
        
    }
    
    /**
     * check input
     */
    func isInputValid()->Bool{
        if self.titleTxt.text!.isEmpty{
            SVProgressHUD .showInfoWithStatus("请输入演出标题")
            return false
        }
        
        if self.descTxt.text!.isEmpty{
            SVProgressHUD .showInfoWithStatus("请输入演出描述")
            return false
        }
        
        if self.dateStartTxt.text!.isEmpty{
            SVProgressHUD .showInfoWithStatus("请输入开始时间")
            return false
        }
        
        if self.dateEndTxt.text!.isEmpty{
            SVProgressHUD .showInfoWithStatus("请输入结束时间")
            return false
        }
        
        if self.currentAddress.addressId.isEmpty{
            SVProgressHUD .showInfoWithStatus("请选择地址")
            return false
        }
        
        return  true
    }
    
    
    /**
     *  发布演出
     */
    func saveAndPublishShow(){
        if self.isInputValid() == false{
            return
        }
        
        self.requestForPublishPerformance()
        
    }
    
    func requestForPublishPerformance(){
        
//        let request = MsRequestModel.requestForPublishShow(self.titleTxt.text!, style: NSArray(), dateStart: self.startTimerval, dateEnd: self.endTimerval, addressId: self.currentAddress.addressId, description: self.descTxt.text!)
//        
//        netWorkMgr.post(request) { (status, result) -> Void in
//            if status == "ok"{
//                self.goBack()
//            }
//        }
        
    }
    
}
