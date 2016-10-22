//
//  MsMyMusicViewController.swift
//  MusicShare
//
//  Created by poleness on 16/1/14.
//  Copyright © 2016年 poleness. All rights reserved.
//

import UIKit

class MsMyMusicViewController: MsBaseViewController {

    
    var userFrom:Int = 0
    var userName:String = ""
    
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
        self.view.backgroundColor = UIColor.msBackGroundColor()
        
        if userFrom == 0{
        self .setNavigationTitle("我的音乐")
        }else{
            let string = self.userName + "的音乐"
            self.setNavigationTitle(string)
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

}
