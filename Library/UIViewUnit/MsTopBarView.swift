//
//  MsTopBarView.swift
//  MusicShare
//
//  Created by poleness on 15/12/28.
//  Copyright © 2015年 poleness. All rights reserved.
//

import UIKit

protocol MsTopBarViewDelegate{
    func didSelectedTopbar(index:Int)
    
}

class MsTopBarView: UIView , UIScrollViewDelegate{
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
    //title
    var titleArray:NSArray = []
    
    //delegate
    var delegate:MsTopBarViewDelegate?
    
    var labelArray:NSMutableArray = []
    var buttonArray:NSMutableArray = []
    
    var selectedIndex:Int = 0
    
    //横向来回滑动的view
    var selectedView:UIView?
    
    
    init(titleArray:NSArray,frame:CGRect = CGRectMake(0, 0, kScreenWidth, 40)){
        super.init(frame: frame)
        
        self.titleArray = NSArray(array: titleArray)
        self.frame = frame
        self.initView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        //        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
    
    func initView(){
        
        
        if self.titleArray.count > 0 {
            let width:CGFloat = CGFloat(kScreenWidth) / CGFloat(self.titleArray.count)

            //选中的view
            self.selectedView = UIView(frame: CGRectMake(0,0,width,self.height()))
            self.selectedView?.backgroundColor = UIColor.msCommonColor()
            self.addSubview(self.selectedView!)
            
            //多个button
            for (var i = 0;i < self.titleArray.count;i++){
                let initX:CGFloat = CGFloat(CGFloat(i) * width)
                
                let button = UIButton(frame: CGRectMake(initX,0,width,self.height()))
                button.tag = i
                button .addTarget(self, action: Selector("selectedActionWithButton:"), forControlEvents: UIControlEvents.TouchUpInside)
                
                self.buttonArray .addObject(button)
                
                let label = UILabel(frame: button.frame)
                label.font = UIFont .systemFontOfSize(14)
                label.textAlignment  = NSTextAlignment.Center
                label.text = self.titleArray .objectAtIndex(i) as? String
                
                if i == 0 {
                    label.textColor = UIColor.whiteColor()
                }else{
                    label.textColor = UIColor.grayColor()
                }
                
                self.labelArray .addObject(label)
                
                
                //风格线
                let line = UIView(frame:CGRectMake(initX + width,0,0.5,self.height()))
                line.backgroundColor = UIColor.msLineColor()
                
                self.addSubview(button)
                self.addSubview(label)
                self.addSubview(line)
            }
            
            
        }
        
        let line = UIView .getLine(self.height()-0.5)
        self.addSubview(line)
        
    }
    
    func selectedActionWithButton(button:UIButton){
        
        self.setCurrentSelected(button.tag)

    }
    
    
    func setCurrentSelected(index:Int){
        
        //代理执行方法
        if self.delegate != nil{
        self.delegate!.didSelectedTopbar(index)
        }
        
        //UI调整
        let initX = CGFloat(index) * CGFloat( kScreenWidth) / CGFloat(self.titleArray.count)
        var frame = self.selectedView?.frame
        frame?.origin.x = initX
        self.selectedView?.frame = frame!
        
        for item in self.labelArray{
            let label = item as! UILabel
            if self.labelArray .indexOfObject(label) == index{
                label.textColor = UIColor.whiteColor()
            }else{
                label.textColor = UIColor.grayColor()
            }
        }
    }
    
//    
//    //uiscrollview delegate
//    func scrollViewDidScroll(scrollView: UIScrollView) {
//        if abs( scrollView.contentOffset.x) > kScreenWidth {
//            return
//        }
//        
//        var frame = self.selectedView?.frame
//        frame?.origin.x =  -scrollView.contentOffset.x
//        self.selectedView?.frame = frame!
//        
//    }
//    
//    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
//        let index = (scrollView.contentOffset.x + 1) / kScreenHeight
//        self.setCurrentSelected(Int(index))
//    }
//    
}


