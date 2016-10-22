//
//  QualCertificateMainViewController.swift
//  MusicShare
//
//  Created by poleness on 16/2/2.
//  Copyright © 2016年 poleness. All rights reserved.
//

import UIKit

class QualCertificateMainViewController: MsBaseViewController {

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
        self.setNavigationTitle("身份审核")
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
