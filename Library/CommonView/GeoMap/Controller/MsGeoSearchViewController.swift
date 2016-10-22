//
//  MsGeoSearchViewController.swift
//  MusicShare
//
//  Created by poleness on 15/12/30.
//  Copyright © 2015年 poleness. All rights reserved.
//

import UIKit


protocol MsGeoSearchViewDelegate{
    func didConfirmedAddress(address:AMapPOI)
}

class MsGeoSearchViewController: MsBaseViewController,MAMapViewDelegate,UISearchBarDelegate ,MsGeoSearchResultDelegate{
    
    
    var searchBar:UISearchBar!
    var delegate :MsGeoSearchViewDelegate?
    
    var searchTableView:MsGeoSearchResultTableView?
    
    //搜索
    var searchModel :MsPoiSearchModel?
    
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
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.searchBar .resignFirstResponder()
        geoMapView.delegate = nil
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        geoMapView.delegate = self
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    func initView(){
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        let right = UIBarButtonItem(title: "取消", style: .Plain, target: self, action: Selector("cancelSearch"))
        
        self.navigationItem.rightBarButtonItem = right
        
        self.view.backgroundColor = UIColor.msBackGroundColor()
        
        self.searchBar = UISearchBar(frame: CGRectMake(0,0,kScreenWidth,30))
        self.searchBar?.showsCancelButton = false
        self.searchBar.delegate = self
        
        self.navigationItem.titleView = self.searchBar
        
        self.initMapView()
        
        
        self.searchTableView = MsGeoSearchResultTableView(frame: CGRectMake(0,kScreenHeight*0.4 - 64,kScreenWidth,kScreenHeight * 0.6 ))
        self.searchTableView?.hidden = true
        self.searchTableView?.delegate = self
        self.view .addSubview(self.searchTableView!)
        
        self.searchBar .becomeFirstResponder()
    }
    
    func initMapView(){
        
        geoMapView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight * 0.4)
        geoMapView.showsUserLocation = true
        geoMapView.delegate = self
        self.view.addSubview(geoMapView)
        
        if geoMapView.userLocation.location != nil {
            let  region:MACoordinateRegion = MACoordinateRegionMakeWithDistance(
                geoMapView.userLocation.location.coordinate, 300,
                300);
            geoMapView .setRegion(region, animated: true)
        }
    }
    
    func initData(){
        if self.searchModel == nil{
            self.searchModel = MsPoiSearchModel()
        }
    }
    
    
    
    /**
     *  UISearchbar delegate
     */
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String){
        if ((self.searchBar.text?.characters.count) != nil) {
            self .searchKeyStringFromGeo()
        }
    }
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self .searchKeyStringFromGeo()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.goBack()
    }
    
    func cancelSearch(){
        self.goBack()
        
    }
    
    
    
    func searchKeyStringFromGeo(){
        let array = NSMutableArray()
        
        for index in 0...10 {
            let poi = AMapPOI()
            poi.name = NSString(format: "这是name%d", index) as String
            poi.address = NSString(format: "这是address%d", index) as String
            
            array .addObject(poi)
        }
        
        self.searchTableView?.hidden = false
        self.searchTableView!.updateData(array)
    }
    
    
    
    //MsGeoSearchResultTableView delegate
    func didSelectAddress(address:AMapPOI){
        self.delegate?.didConfirmedAddress(address)
        
        self .goBack()
    }
    
}
