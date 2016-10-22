//
//  MsSearchMainViewController.swift
//  MusicShare
//
//  Created by poleness on 15/12/5.
//  Copyright © 2015年 poleness. All rights reserved.
//

import UIKit

class MsSearchMainViewController: MsBaseViewController,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate {
    
    var menuArray = NSMutableArray()
    var dataArray = NSMutableArray()
    
    var page = 0
    var totalPage = 0
    
    //UI
    var tableView: UITableView?
    var searchBar: UISearchBar?;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if ((self.searchBar?.isFirstResponder()) != nil) {
            self.searchBar? .resignFirstResponder()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setNavigationMusicianImage()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initView(){
        
        self .setLeftBackImageWithWhite()
        
        self.tableView = UITableView(frame: CGRectMake(0, 0, kScreenWidth, kScreenHeight ), style :.Grouped)
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        self.view .addSubview(self.tableView!)
        
        self.searchBar = UISearchBar()
        self.searchBar?.delegate = self
//        self.searchBar?.showsCancelButton = true
        self.searchBar?.tintColor = UIColor.systemNavBlue()
        self.searchBar?.placeholder = "搜索您想要的乐谱，乐器，乐手"
        self.searchBar? .becomeFirstResponder()
        
        for view in (self.searchBar?.subviews)! {
            let array =  view.subviews as NSArray
            if array.count > 0 {
                let subView = array .objectAtIndex(0) as! UIView
                subView.removeFromSuperview()
            }
        }
        
        self.navigationItem.titleView = self.searchBar
        
        
        let right = UIBarButtonItem(title: "筛选", style: UIBarButtonItemStyle.Plain, target: self, action: "siftResultAction")
        self.navigationItem.rightBarButtonItem = right
        
    }
    
    func setCancelWhiteColor() {
        
        for view in self.searchBar!.subviews {
            if (view .isKindOfClass(UIView)) {
                for  subView in view.subviews {
                    //修改cancel 按钮颜色
                    if (subView .isKindOfClass(UIButton)) {
                        let button = subView as! UIButton
                        button .setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                        button .setTitleColor(UIColor.whiteColor(), forState: UIControlState.Selected)
                    }
                }
            }
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
    
    
    // MARK:tableviewdelegate
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1;
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let rand = section % 3
        if rand == 0 {
            return "乐谱"
        }else if rand == 1 {
            return "器材/设备"
        }else{
            return "乐手"
        }
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.menuArray.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.menuArray[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "MsSearchMainViewControllerCell"
        
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        
        if (cell == nil) {
            cell = UITableViewCell(style:UITableViewCellStyle.Value1, reuseIdentifier:cellIdentifier)
        }
        
        //        cell?.delegate = self
        cell!.backgroundColor = UIColor .whiteColor()
        
        let section = indexPath.section
        let row = indexPath.row
        
        cell?.contentView .removeAllSubviews()
        cell?.imageView?.image = nil
        
        cell?.textLabel?.numberOfLines = 0
        cell?.textLabel?.font = UIFont.systemFontOfSize(15.0)
        //        cell.imageView.setImageWithURL(NSURL(string: imageArr[indexPath.row] as String)!, placeholderImage: UIImage(named: "icon.png"))
        
        
        if section < self.menuArray.count {
            
            let array = self.menuArray[section] as! NSArray
            if row < array.count{
                let dic = array[row] as! NSDictionary
                let imgName = dic.objectForKey("image") as! NSString
                let text = dic.objectForKey("text") as! NSString
                
                let text_M = NSMutableString(string: text)
                let length =  text_M.length
                if length > 0{
                    let position = Int(arc4random_uniform(UInt32(length)))
                    text_M .insertString((self.searchBar?.text)!, atIndex: position)
                }
                
                cell!.textLabel!.text = text_M as String
                
                cell?.imageView?.image = UIImage(named: imgName as String)
            }
            
        }
        
        return cell!
    }
    
    ///
    /// UITableViewDelegate
    ///
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //        var index = indexPath.row
        //        var data = self.dataSource[index] as! NSDictionary
        //
        return  60
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView .deselectRowAtIndexPath(indexPath, animated:true )
        
        let array = self.menuArray[indexPath.section] as! NSArray
        let dic = array[indexPath.row] as! NSDictionary
        var text = dic.objectForKey("text") as! NSString
        text = text .substringToIndex(text.length/3)
        
        let rand = indexPath.section % 3

        let subVC :MsBaseViewController
        if rand == 0 {
            subVC = MsGoodsMainViewController()
            subVC.navigationItem.title = NSString(format:"乐谱:%@", text) as String

        }else if rand == 1 {
            subVC = MsGoodsMainViewController()
            subVC.navigationItem.title = NSString(format:"乐器:%@", text) as String

        }else{
            subVC = MsMusicianMainViewController()
            subVC.navigationItem.title = NSString(format:"乐手:%@", text) as String

        }
        
        self .hidePushViewController(subVC, animated: true)
    }
    
    
    // MARK: searchbardelegae
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.requestForSearchData()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar){
        self.goBack()
        
    }
    
    
    
    //网络请求
    func requestForSearchData(){
        //        if incremental{
        //            self.page >= self.totalPage
        //            return
        //        }else{
        //            self.page++
        //        }
        
        self.menuArray .removeAllObjects()
        
        for (var i=0; i<10;i++){
            
            let array_M  = NSMutableArray()
            
            let luckyNumber = Int(arc4random() % 5 + 1)
            
            for (var j = 0;j < luckyNumber;j++){
                if j % 2 == 0{
                    let dic = NSMutableDictionary()
                    dic.setObject("rock and roll also called rock music", forKey: "text")
                    let temp = NSString(format: "temp_%d", arc4random_uniform(11) + 1)
                    dic.setObject(temp, forKey: "image")
                    array_M .addObject(dic)
                }else{
                    let dic = NSMutableDictionary()
                    dic.setObject("Music share and start the world", forKey: "text")
                    let temp = NSString(format: "temp_%d", arc4random_uniform(11) + 1)
                    dic.setObject(temp, forKey: "image")
                    array_M .addObject(dic)
                    
                }
            }
            
            self.menuArray .addObject(array_M)
        }
        
        
        self.tableView?.reloadData()
    }
    
    //MARK: UIScrollViewDelegate
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.searchBar?.resignFirstResponder()
    }
    
    
    //MARK: ACTION
    
    //筛选
    func siftResultAction(){
        
    }
    
    
    
}
