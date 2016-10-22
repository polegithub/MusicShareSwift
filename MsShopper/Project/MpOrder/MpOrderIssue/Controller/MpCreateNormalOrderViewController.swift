//
//  MpCreateNormalOrderViewController.swift
//  MusicShare
//
//  Created by poleness on 16/1/26.
//  Copyright © 2016年 poleness. All rights reserved.
//

import UIKit
import SVProgressHUD

class MpCreateNormalOrderViewController: MsBaseViewController,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate ,MsMyAddressListDelegate,MpOrderTimeGroupDelegate{
    
    let left_tag = 0
    let right_tag = 1
    
    let title_row = 0
    let desc_row = 1
    let time_row = 0
    let location_row = 1
    let style_row = 2
    
    let cellTitleWidth:CGFloat = 100 //左侧标题width
    let bottomHeight:CGFloat = 50 //底部view高度
    
    var tableView:UITableView?
    var descTxt = UITextView()
    
    let descPlaceholder = "请输入详细需求"
    
    //tag
    var tag_title_textField = 1
    var tag_desc_textView = 2
    
    //data
    var orderTitle:String = ""
    var orderDesc:String = ""
    var styleArray = NSMutableArray()
    var photoArray = NSArray()
    var timeArray = NSArray()
    var totalPrice:Double = 0
    
    //底部view
    var priceValue:UILabel?
    var bottomView:UIView?
    
    
    //风格
    var needStyle:Int = 0 //0表示初始状态，1表示设置过 2 表示不需要
    var allStyleArray = NSArray()
    var styleLines = 0
    
    //地址
    var addressModel :MsAddressModel?
    
    //状态
    var isShowStyle:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
        self.initData()
        self.addNotification()
        
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
        
        self.view.backgroundColor = UIColor.msBackGroundColor()
        self .setLeftBackImageWithWhite()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        self.tableView = UITableView(frame: CGRectMake(0, 0, kScreenWidth, kScreenHeight), style :.Grouped)
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        self.tableView?.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
        
        self.view .addSubview(self.tableView!)
        
        self.setNavigationTitle("演出招聘")
        self.setNavigationMusicianImage()
        
        self.descTxt = UITextView(frame: CGRectMake(10,0,kScreenWidth - 25,66))
        descTxt.font = UIFont.msCellFont()
        descTxt.tag = tag_desc_textView
        descTxt.delegate = self
        
        //右侧导航
        let right = UIBarButtonItem(title: "发布", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("OrderIssueAction"))
        self.navigationItem.rightBarButtonItem = right
        
        //底部按钮
        let priceTitle = UILabel(frame: CGRectMake(15,0,50,bottomHeight))
        priceTitle.text = "需支付:"
        priceTitle.font = UIFont.systemFontOfSize(13)
        priceTitle.textColor = UIColor.whiteColor()
        
        self.priceValue = UILabel(frame: CGRectMake(60,0,kScreenWidth - 100 - 150,bottomHeight))
        self.priceValue!.textColor = UIColor.orangeColor()
        self.priceValue?.text = NSString(format: "%.1f元", self.totalPrice) as String
        self.priceValue?.textAlignment = NSTextAlignment.Left
        
        let rightBtn = UIButton(frame: CGRectMake(kScreenWidth - 120,bottomHeight/2-30/2,100,30))
        rightBtn.tag = right_tag
        rightBtn.setTitle("提交订单", forState: UIControlState.Normal)
        rightBtn .addTarget(self, action: Selector("OrderIssueAction"), forControlEvents: UIControlEvents.TouchUpInside)
        rightBtn.titleLabel?.font = UIFont.msCellFont()
        rightBtn.layer.borderColor = UIColor.whiteColor().CGColor
        rightBtn.layer.borderWidth = 1
        
        self.bottomView = UIView(frame: CGRectMake(0,kScreenHeight - bottomHeight - 64,kScreenWidth,bottomHeight))
        self.bottomView?.backgroundColor = UIColor.msCommonColor()
        
        self.bottomView!.addSubview(priceTitle)
        self.bottomView!.addSubview(self.priceValue!)
        self.bottomView!.addSubview(rightBtn)
        self.view .addSubview(self.bottomView!)
        
        
        
    }
    
    func initData(){
        self.requestForAllStyleData() //请求演出风格类型
    }
    
    func addNotification(){
        NSNotificationCenter .defaultCenter() .addObserver(self, selector: Selector("orderTextFieldChanged:"), name: UITextFieldTextDidChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter() .addObserver(self, selector: Selector("orderTextViewChanged:"), name: UITextViewTextDidChangeNotification, object: nil)
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
    * Unit
    */
    //时间的高度
    func heightForTimeCell()->CGFloat{
        var height:CGFloat = 44
        if self.timeArray.count > 1 {
            height = CGFloat(self.timeArray.count) * 30
        }
        return height
    }
    
    func heightForAddressCell()->CGFloat{
        var height:CGFloat = 0
        if self.addressModel == nil{
            height = 44.0
        }else{
            height = 66.0
        }
        return height
    }
    
    
    
    func currentStyleView()->UIView{
        
        let view = UIView()
        
        self.styleLines = 1
        var widthSum:CGFloat = 0
        for item in self.allStyleArray{
            let model = item as! MpStyleModel
            let title = model.styleName
            let width = title .textSize(15, maxWidth: 100, maxHeight: 20).width + 10
            if widthSum > kScreenWidth - 30 - width - 15 {
                styleLines += 1
                widthSum = 0
            }
            let initY = CGFloat(styleLines - 1) * 40 + 10
            let button = self.baseButton(title)
            button.frame = CGRectMake(widthSum+15,initY,width,24)
            button .addTarget(self, action: Selector("selectTagButton:"), forControlEvents: UIControlEvents.TouchUpInside)
            
            if self.styleArray .containsObject(item){
                button.backgroundColor = UIColor.msCommonColor()
                button .setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            }
            
            view .addSubview(button)
            
            //每行累加
            widthSum  += width + 15
        }
        
        let height :CGFloat = CGFloat(styleLines ) * 44.0
        view.frame = CGRectMake(15,44,kScreenWidth - 30,height)
        
        return view
        
    }
    
    //button 的基本属性
    func baseButton(title:String)->UIButton{
        let button = UIButton()
        button .setTitle(title, forState: UIControlState.Normal)
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.msCommonColor().CGColor
        button.backgroundColor = UIColor.clearColor()
        button.titleLabel?.font = UIFont.systemFontOfSize(15)
        button .setTitleColor(UIColor.msCommonColor(), forState: UIControlState.Normal)
        
        return button
    }
    
    //cell的title
    func baseCellTitle(title:String)->UILabel{
        let label = UILabel(frame: CGRectMake(cellLeftMargin,0,cellTitleWidth,44))
        label.font = UIFont.msCellFont()
        label.textAlignment = NSTextAlignment.Left
        label.textColor = UIColor.lightGrayColor()
        label.text = title
        
        return label
    }
    
    //地址view
    func addressDetailView()->UIView{
        let height = self.heightForAddressCell()
        let view = UIView(frame: CGRectMake(cellTitleWidth,0,kScreenWidth - cellTitleWidth - 30,height))
        if self.addressModel == nil{
            let label = self.defaultSettingLabel("请设置")
            view .addSubview(label)
        }else{
            let name = UILabel(frame: CGRectMake(0,0,view.width(),44))
            name.text = self.addressModel?.addressName
            name.font = UIFont.msCellFont()
            name.textColor = UIColor.blackColor()
            name.textAlignment = NSTextAlignment.Right
            
            let address = UILabel(frame: CGRectMake(0,height/2,view.width(),height / 2))
            address.textColor = UIColor.lightGrayColor()
            address.text = self.addressModel?.addressDetail
            address.textAlignment = NSTextAlignment.Right
            address.font = UIFont.msCellFont()
            
            view .addSubview(name)
            view.addSubview(address)
        }
        
        
        return view
    }
    
    //"请设置label"
    func defaultSettingLabel(title:String)->UILabel{
        let label = UILabel(frame: CGRectMake(0,0,kScreenWidth - 30,44))
        label.textAlignment = NSTextAlignment.Right
        label.font = UIFont.msCellFont()
        label.text = title
        label.textColor = UIColor.msPlaceholderColor()
        
        return label
    }
    
    //时间
    func timeDetailView()->UIView{
        let height = self.heightForTimeCell()
        let view = UIView(frame: CGRectMake(0,0,kScreenWidth,height))
        
        if self.timeArray.count > 0 {
            for model  in self.timeArray{
                let timeModel = model as! MpOrderTimeModel
                let label = self.baseTimeLabel(timeModel.timeStart)
                label.text = timeModel.timeStart.timeStrWithFormat() + "~..."
                label.textColor = UIColor.blackColor()
                
                let index = self.timeArray .indexOfObject(model)
                var frame = label.frame
                if self.timeArray.count == 1{
                    //单独一个的时候，需要居中
                    frame.origin.y = 44 / 2 - 30 / 2
                }else{
                    frame.origin.y = frame.origin.y + CGFloat(CGFloat(index) * frame.height)
                    
                }
                label.frame = frame
                
                view .addSubview(label)
            }
            
        }else{
            let label = self.defaultSettingLabel("请设置")
            view .addSubview(label)
        }
        
        return view
        
    }
    func baseTimeLabel(timeStr:String)->UILabel{
        let label = UILabel(frame: CGRectMake(0,0,kScreenWidth - 30,30))
        label.textAlignment = NSTextAlignment.Right
        label.text = timeStr.timeStrWithFormat()
        label.textColor = UIColor.lightGrayColor()
        label.font = UIFont.msCellFont()
        
        return label
    }
    
    
    //标题+ 描述信息
    
    ///uitextfield changed
    func orderTextFieldChanged(notificatoin:NSNotification){
        let textField:UITextField = notificatoin.object as! UITextField
        if textField.tag == tag_title_textField{
            self.orderTitle = textField.text!
        }
    }
    
    func orderTextViewChanged(notificatoin:NSNotification){
        let textField:UITextView = notificatoin.object as! UITextView
        if textField.tag == tag_desc_textView{
            
            self.orderDesc = textField.text!
            textField.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidBeginEditing(textView: UITextView){
        if self.descTxt.text == descPlaceholder {
            self.descTxt.text = ""
        }
    }
    func textViewDidEndEditing(textView: UITextView) {
        if self.descTxt.text.isEmpty{
            self.descTxt.text = descPlaceholder
            self.descTxt.textColor = UIColor.msPlaceholderColor()
        }
    }
    
    
    ///
    /// UITableViewDataSource
    ///
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }else{
            if self.allStyleArray.count > 0 {
                return 3
            }else{
                return 2
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "orderDetailTransporterInfoTel"
        
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        
        if (cell == nil) {
            cell = UITableViewCell(style:UITableViewCellStyle.Value1, reuseIdentifier:cellIdentifier)
        }
        
        
        cell?.contentView .removeAllSubviews()
        
        cell!.textLabel!.font = UIFont.systemFontOfSize(15.0)
        cell!.detailTextLabel?.font = UIFont.systemFontOfSize(14.0)
        
        cell?.textLabel?.textColor = UIColor.blackColor()
        cell?.detailTextLabel?.textColor = UIColor.blackColor()
        
        cell?.textLabel?.text = ""
        cell?.detailTextLabel?.text = ""
        cell?.imageView?.image = nil
        
        cell?.accessoryType = UITableViewCellAccessoryType.None
        cell?.selectionStyle = UITableViewCellSelectionStyle.Gray
        
        
        let row = indexPath.row
        let section = indexPath.section
        
        if section == 0{
            if row == title_row{
                let titleTxt = UITextField(frame: CGRectMake(15,0,kScreenWidth - 30,44))
                titleTxt.font = UIFont.msCellFont()
                titleTxt.placeholder = "请输入主题"
                titleTxt.text = self.orderTitle
                titleTxt.tag = tag_title_textField
                
                cell?.contentView .addSubview(titleTxt)
                
            }else if row == desc_row{
                if self.orderDesc.isEmpty{
                    descTxt.text = descPlaceholder
                    descTxt.textColor = UIColor.msPlaceholderColor()
                }else{
                    descTxt.text = self.orderDesc
                    descTxt.textColor = UIColor.blackColor()
                }
                cell?.contentView .addSubview(self.descTxt)
                
            }
        }else{
            if row == time_row{
                let label = self .baseCellTitle("演出时间")
                
                cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                
                cell?.contentView .addSubview(label)
                cell?.contentView .addSubview(self.timeDetailView())
                
            }else if row == location_row{
                cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                let label = self .baseCellTitle("演出地点")
                cell?.contentView .addSubview(label)
                
                cell?.contentView .addSubview(self.addressDetailView())
                
            }else if row == style_row {
                
                cell?.selectionStyle = UITableViewCellSelectionStyle.None
                cell?.accessoryView = UIImageView(image: UIImage(named: "right_array_gray"))
                let label = self .baseCellTitle("演出风格")
                cell?.contentView .addSubview(label)
                
                let imageView = UIImageView(frame: CGRectMake(kScreenWidth - 30, 44/2 - 8/2 , 14, 8))
                
                if self.isShowStyle{
                    cell?.contentView .addSubview(self.currentStyleView())
                    imageView.image = UIImage(named: "up_arrow_gray")
                }else{
                    imageView.image = UIImage(named: "down_arrow_gray")
                }
                cell?.contentView .addSubview(imageView)
            }
        }
        
        return cell!
    }
    
    ///
    /// UITableViewDelegate
    ///
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0{
            if indexPath.row == desc_row{
                return 66
            }
        }else if indexPath.section == 1{
            if indexPath.row == style_row{
                if self.isShowStyle == true{
                    //展示风格
                    return CGFloat(self.styleLines + 1) * 44.0
                }
            }else if indexPath.row == location_row{
                return self.heightForAddressCell()
            }else  if indexPath.row == time_row {
                return self.heightForTimeCell()
            }
        }
        return  44
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView .deselectRowAtIndexPath(indexPath, animated:true )
        
        
        let row = indexPath.row
        if row == time_row {
            
            let subVC = MpOrderTimeGroupViewController()
            subVC.delegate = self
            subVC.dataArray = NSMutableArray(array: self.timeArray)
            let nav = UINavigationController(rootViewController: subVC)
            self.presentViewController(nav, animated: true, completion: nil)
            //            self.hidePushViewController(subVC, animated: true)
            
        }else if row == location_row{
            
            let subVC = MsMyAddressListViewController()
            subVC.delegate = self
            self.hidePushViewController(subVC, animated: true)
            
        }else if row == style_row{
            self.isShowStyle = !self.isShowStyle
            
            let path = NSIndexPath(forRow: style_row, inSection: 1)
            self.tableView!.reloadRowsAtIndexPaths([path], withRowAnimation: UITableViewRowAnimation.Fade)
            
        }
        
        
    }
    
    /**
     Action
     */
     //设置了时间
    func didFinishTimeGroupData(array:NSArray){
        self.timeArray = array
        self.tableView!.reloadData()
        
        if array.count > 0 {
            var price:Double = 0
            
            for item in array{
                let model:MpOrderTimeModel =  item as! MpOrderTimeModel
                price += Double(model.price)!
            }
            self.totalPrice = price
            self.priceValue?.text = NSString(format: "%.1f", self.totalPrice) as String
        }
    }
    
    
    //选择了风格
    func selectTagButton(button:UIButton){
        let title = button.titleLabel?.text

        if title != nil{
            let model = self .getStyleByTitle(title!)
            if self.isCurrentContainedStyle(model){
                self.styleArray .removeObject(model)
            }else{
                self.styleArray .addObject(model)
            }
            self.tableView!.reloadData()
        }
    }
    
    //风格base 
    func isCurrentContainedStyle(style:MpStyleModel)->Bool{

        var isInclude = false
        for item in self.styleArray{
            let model = item as! MpStyleModel
            if model.styleName == style.styleName && model.styleId == style.styleId {
                isInclude = true
            }
        }

        return isInclude
    }
    
    func getStyleByTitle(title:String)->MpStyleModel{
        if title.isEmpty == false{
            if self.allStyleArray.count > 0 {
                for item in self.allStyleArray{
                    let model = item as! MpStyleModel
                    if model.styleName == title{
                        return model
                    }
                }
            }
        }
        
        return MpStyleModel()
    }
    
    
    //选择了地址
    func didSelectAddress(address:MsAddressModel){
        self.addressModel = address
        self.tableView!.reloadData()
    }
    
    //发布订单
    func OrderIssueAction(){
        if self.isInputValid() == false{
            return
        }
        
        self.requestForIssueOrder()
    }
    
    /**
     * 数据处理
     */
     //check is input valid
    func isInputValid()->Bool{
        if self.orderTitle.isEmpty{
            SVProgressHUD .showInfoWithStatus("请输入您的招聘的主题")
            return false
        }
        
        if self.orderDesc.isEmpty{
            SVProgressHUD .showInfoWithStatus("请详细描述您的招聘需求")
            return false
        }
        
        if self.timeArray.count == 0 {
            SVProgressHUD .showInfoWithStatus("请设置演出时间")
            return false
        }
        
        if self.addressModel == nil{
            SVProgressHUD .showInfoWithStatus("请选择演出地址")
            return false
        }
        return true
        
    }
    
    //网络请求的数据格式化
    func formatTimeArray()->NSArray{
        let array = NSMutableArray()
        for item in self.timeArray{
            let dic = NSMutableDictionary()
            let model :MpOrderTimeModel = item as! MpOrderTimeModel
            dic .setValue(model.price, forKey: "price")
            dic .setValue(model.timeStart, forKey: "starttime")
            dic.setValue(model.timeEnd, forKey: "endtime")
            dic.setValue(model.deadline, forKey: "deadline")
            dic.setValue(String(model.peopleCount), forKey: "needcount")
            array .addObject(dic)
        }
        
        return NSArray(array: array)
    }
    
    func formatStyleArray()->NSArray{
        let array = NSMutableArray()
        for item in self.styleArray{
            let model = item as! MpStyleModel
            let dic = NSDictionary(object: model.styleId, forKey: "type")
            array .addObject(dic)
        }
        
        return NSArray(array: array)
    }
    
    
    
    
    //网络请求
    func requestForIssueOrder(){
        var addressId = ""
        if self.addressModel != nil{
            addressId = self.addressModel!.addressId
        }
        let arrayTime = self.formatTimeArray()
        let arrayStyle = self.formatStyleArray()
        
        let request = MsRequestModel.requestForShopCreateOrder(userMgr.userInfo.userId, title: self.orderTitle, style: arrayStyle, timeArray:arrayTime , addressId:addressId, description: self.orderDesc)
        netWorkMgr.post(request) { (status, result) -> Void in
            
            if status == "ok" {
                SVProgressHUD .showInfoWithStatus("发布成功")
                
                self.goBack()
                NSNotificationCenter .defaultCenter() .postNotificationName(kNotificationIssueNewOrder, object: self, userInfo: nil)
            }
        }
    }
    
    
    //获取全部的演出风格类型
    func requestForAllStyleData(){
        let request = MsRequestModel.requestForShopOrderStyleList()
        netWorkMgr.post(request) { (status, result) -> Void in
            
            if status == "ok" {
                if result != nil{
                    let playBoard: NSArray = (result!["payload"] as? NSArray)!
                    
                    if playBoard.count > 0 {
                        let array_M = NSMutableArray()
                        for item in playBoard{
                            
                            let model = MpStyleModel(styleDic: item as! NSDictionary)
                            array_M .addObject(model)
                        }
                        self.allStyleArray = NSArray(array: array_M)
                        self.tableView!.reloadData()
                    }
                }
            }
        }
    }
    
    
    
}
