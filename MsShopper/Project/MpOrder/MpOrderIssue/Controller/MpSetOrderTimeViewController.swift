//
//  MpSetOrderTimeViewController.swift
//  MusicShare
//
//  Created by poleness on 16/1/26.
//  Copyright © 2016年 poleness. All rights reserved.
//

import UIKit
import SVProgressHUD
import ActionSheetPicker_3_0

let time_start_row = 0
let time_end_row = 1
let time_deadline_row = 2

protocol MpSetOrderTimeDelegate{
    func didFinishAddNewTimeModel(timeModel: MpOrderTimeModel)
    func didFinishModifyTimeModel()
}

class MpSetOrderTimeViewController: MsBaseViewController,UITableViewDataSource,UITableViewDelegate ,UITextFieldDelegate{
    
    //delegate
    var delegate:MpSetOrderTimeDelegate?
    
    var datePick = UIDatePicker()
    
    var isModify:Bool = false
    
    //tag
    let people_txt_tag = 99
    let price_tag = 101
    
    
    var tableView:UITableView?
    
    var countSwitch = UISwitch()
    
    var timeModel = MpOrderTimeModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        self.initData()
        
        self.addNotification()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func initView(){
        self .setNavigationTitle("时间设置")
        self.setLeftBackImageWithWhite()
        self.view.backgroundColor = UIColor.msBackGroundColor()
        
        //保存
        let right  = UIBarButtonItem(title: "完成", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("saveTimeModel"))
        self.navigationItem.rightBarButtonItem = right
        
        
        self.tableView = UITableView(frame: CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64), style: UITableViewStyle.Grouped)
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        
        self.view .addSubview(self.tableView!)
        
        //多人开关
        self.countSwitch .addTarget(self, action: Selector("switchValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        
        self.countSwitch.frame = CGRectMake(kScreenWidth/2, 0, 20, 20)
        
        
        //datePick
        self.datePick = UIDatePicker(frame: CGRectMake(0,kScreenHeight - 216,kScreenWidth,216))
        self.datePick.backgroundColor = UIColor.whiteColor()
        self.datePick.locale = NSLocale(localeIdentifier: "zh_CN")
        self.datePick.datePickerMode = UIDatePickerMode.DateAndTime
        self.datePick.addTarget(self, action: Selector("datePickValueChanged:"), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func initData(){
        if self.isModify == false{
            //非修改状态下，默认是1人
            self.timeModel.peopleCount = 1
        }
    }
    
    func addNotification(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("textfieldChanged:"), name: UITextFieldTextDidChangeNotification, object: nil)
    }
    
    //保存退出
    func saveTimeModel(){
        if self.isValieTimeModel(self.timeModel){
            if self.isModify == true{
                //修改
                self.delegate?.didFinishModifyTimeModel()
            }else{
                //添加
                self.delegate? .didFinishAddNewTimeModel(self.timeModel)
            }
            self .goBack()
        }
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
    
    func isValieTimeModel(timeModel:MpOrderTimeModel)->Bool{
        if self.isValidTimeString(timeModel.timeStart) == false {
            SVProgressHUD .showInfoWithStatus("请输入开始时间")
            return false
        }
        if self.isValidTimeString(timeModel.timeEnd) == false {
            SVProgressHUD .showInfoWithStatus("请输入结束时间")
            return false
        }
        if self.isValidTimeString(timeModel.deadline) == false {
            SVProgressHUD .showInfoWithStatus("请输入报名截止时间")
            return false
        }
        if timeModel.peopleCount < 1 {
            SVProgressHUD .showInfoWithStatus("请确认人数")
            
            return false
        }
        
        let priceStr = timeModel.price as NSString
        
        if  priceStr.intValue <= 0{
            SVProgressHUD .showInfoWithStatus("请输入演出费用")
            return  false
        }
        
        return true
    }
    
    //是否是有效的time string
    func isValidTimeString(string:String)->Bool{
        if string.isEmpty{
            return false
        }
        if Int(string) <= 0 {
            return false
        }
        return true
    }
    
    
    //textfiled changed
    func textfieldChanged(notification:NSNotification){
        let textfield:UITextField = notification.object as! UITextField
        if textfield.tag == people_txt_tag {
            if textfield.text != nil && textfield.text!.isEmpty == false{
                if textfield.text!.isValidNumber() == true{
                    self.timeModel.peopleCount = Int(textfield.text!)!
                }else{
                    SVProgressHUD .showInfoWithStatus("只能输入数字")
                    textfield.text = "2"
                    self.timeModel.peopleCount = 2
                }
            }else{
                self.timeModel.peopleCount = 2
            }
        }else if textfield.tag == price_tag{
            if textfield.text != nil && textfield.text!.isEmpty == false{
                
                if textfield.text!.isValidNumber() == true{
                    self.timeModel.price = textfield.text!
                }else{
                    SVProgressHUD .showInfoWithStatus("只能输入数字")
                    textfield.text = ""
                }
            }else{
                self.timeModel.price = ""
                
            }
        }
    }
    
    
    ///
    /// UITableViewDataSource
    ///
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }else  {
            if self.countSwitch.on == true{
                return 3
            }
            return 2
        }
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 1{
            let view = UIView(frame: CGRectMake(0,0,kScreenWidth,44))
            let label = UILabel(frame: CGRectMake(0,0,kScreenWidth-15,44))
            label.text = "建议参考费用：￥300/场"
            label.font = UIFont.msCellFont()
            label.textAlignment = NSTextAlignment.Right
            label.textColor = UIColor.lightGrayColor()
            view .addSubview(label)
            
            return view
        }
        return UIView()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "MpSetOrderTimeViewControllerCell"
        
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
        cell?.imageView?.image = nil
        
        let row = indexPath.row
        
        if indexPath.section == 0{
            
            cell?.selectionStyle = UITableViewCellSelectionStyle.Default
            cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            
            if row == time_start_row {
                cell?.textLabel?.text = "开始时间"
                if  Int(self.timeModel.timeStart) > 0{
                    cell?.detailTextLabel?.text = self.timeModel.timeStart .timeStrWithFormat()
                }
                
            }else if row == time_end_row {
                cell?.textLabel?.text = "结束时间"
                if  Int(self.timeModel.timeEnd) > 0 {
                    cell?.detailTextLabel!.text = self.timeModel.timeEnd.timeStrWithFormat()
                }
            }else if row == time_deadline_row {
                cell?.textLabel?.text = "报名截止时间"
                if  Int(self.timeModel.deadline) > 0 {
                    cell?.detailTextLabel?.text = self.timeModel.deadline.timeStrWithFormat()
                }
            }
            
        }else if indexPath.section == 1{
            cell?.selectionStyle = UITableViewCellSelectionStyle.None
            cell?.accessoryType = UITableViewCellAccessoryType.None
            
            if row == 0 {
                cell?.textLabel?.text = "多人表演"
                cell?.accessoryView = self.countSwitch
            }
            
            let feeRow = self.countSwitch.on ? 2:1
            if row == feeRow{
                cell?.textLabel?.text = "出场费（元/场）"
                
                let textField = UITextField(frame: CGRectMake(kScreenWidth - 100,0,100,44))
                textField.minimumFontSize = 0.5
                textField.font = UIFont.msCellFont()
                textField.tag = price_tag
                textField.textAlignment = NSTextAlignment.Center
                textField.keyboardType = UIKeyboardType.NumberPad
                textField.backgroundColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.5)
                textField.text = self.timeModel.price
                
                cell?.contentView .addSubview(textField)
            }
            
            if row == 1 && self.countSwitch.on == true{
                
                let descLabel = UILabel(frame: CGRectMake(kScreenWidth - 150,0,50,44))
                descLabel.text = "人数"
                descLabel.textColor = UIColor.lightGrayColor()
                descLabel.font = UIFont.msCellFont()
                
                let textField = UITextField(frame: CGRectMake(kScreenWidth - 100,0,100,44))
                textField.minimumFontSize = 0.5
                textField.font = UIFont.msCellFont()
                textField.tag = people_txt_tag
                textField.textAlignment = NSTextAlignment.Center
                textField.keyboardType = UIKeyboardType.NumberPad
                textField.backgroundColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.5)
                
                if self.timeModel.peopleCount < 2{
                    self.timeModel.peopleCount = 2
                    textField.text = "2"
                }else{
                    textField.text = String(self.timeModel.peopleCount)
                }
                cell?.contentView .addSubview(descLabel)
                cell?.contentView.addSubview(textField)
            }
            
            
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
        
        if indexPath.section == 0{
            self .showTimePickAction(indexPath.row)
        }
    }
    
    /**
     *  Action
     */
    func switchValueChanged(swich:UISwitch){
        if swich.on == false{
            self.timeModel.peopleCount = 1
        }
        
        self.tableView!.reloadData()
    }
    
    func dismissKeyboard(){
        //        self
    }
    
    
    //点击时间
    func showTimePickAction(index:Int) {
        self.dismissKeyboard()
        
        var title = ""
        if index == time_end_row {
            title = "选择结束时间"
        }else if index == time_start_row{
            title = "选择开始时间"
        }else{
            title = "选择截止时间"
        }
        
        ActionSheetDatePicker .showPickerWithTitle(title, datePickerMode: UIDatePickerMode.DateAndTime, selectedDate: NSDate(), doneBlock: { (pick, date, origin) -> Void in
            
            if index == time_start_row {
                
                let starttimeD:Double = date.timeIntervalSince1970
                let endDouble = Double(self.timeModel.timeEnd)
                if  endDouble > 0 {
                    if starttimeD <= endDouble {
                        SVProgressHUD.showInfoWithStatus("须早于结束时间")
                        return
                    }
                }
                
                self.timeModel.timeStart = NSString(format: "%.0f", starttimeD) as String
                if self.timeModel.deadline.isEmpty{
                    //默认是开始的前1小时
                    self.timeModel.deadline = NSString(format: "%.0f", date.timeIntervalSince1970 - 3600) as String
                }
            }else if index == time_end_row {
                let endtimeD:Double = date.timeIntervalSince1970
                let startD = Double(self.timeModel.timeStart)!
                
                if  startD == 0 {
                    SVProgressHUD.showInfoWithStatus("请先选择开始时间")
                    return
                }
                if startD >= endtimeD {
                    SVProgressHUD.showInfoWithStatus("结束时间必须晚于开始时间")
                    return
                }
                
                self.timeModel.timeEnd = NSString(format: "%.0f", endtimeD) as String
                
            }else{
                let deadlineD:Double = date.timeIntervalSince1970
                let startD = Double(self.timeModel.timeStart)!
                if  startD == 0 {
                    SVProgressHUD.showInfoWithStatus("请先选择开始时间")
                    return
                }
                if startD <= deadlineD {
                    SVProgressHUD.showInfoWithStatus("截止时间不能晚于开始时间")
                    return
                }
                self.timeModel.deadline = NSString(format: "%.0f", deadlineD) as String
            }
            
            self.tableView!.reloadData()
            
            }, cancelBlock: { (pick) -> Void in
                
            }, origin: self.view)
        
    }
    
    
}
