//
//  MpNeedLoginView.swift
//  MusicShare
//
//  Created by poleness on 16/2/22.
//  Copyright © 2016年 poleness. All rights reserved.
//

import UIKit

protocol MpNeedLoginViewDelegate{
    func enterLoginView()
    
}

class MpNeedLoginView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    var loginButton:UIButton!
    var delegate:MpNeedLoginViewDelegate?
    
    init(delegate:MpNeedLoginViewDelegate,frame:CGRect = CGRectMake(0, 0, kScreenWidth, kScreenHeight)) {
        self.delegate = delegate
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.whiteColor()
        
        self.loginButton = UIButton(frame: CGRectMake(kScreenWidth/2 - 100 / 2,kScreenHeight/2 - 44/2 - 50,100,44))
        self.loginButton .setTitle("登录", forState: UIControlState.Normal)
        self.loginButton.backgroundColor = UIColor.msCommonColor()
        self.loginButton .setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.loginButton .addTarget(self, action: Selector("loginAction"), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.loginButton.layer.cornerRadius = 5.0
        self.loginButton.clipsToBounds = true
        
        self.addSubview(self.loginButton)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func loginAction(){
        self.delegate? .enterLoginView()
    }
    

}
