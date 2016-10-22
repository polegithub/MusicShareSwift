//
//  MsAddressListTableViewCell.swift
//  MusicShare
//
//  Created by poleness on 16/1/2.
//  Copyright © 2016年 poleness. All rights reserved.
//

import UIKit

class MsAddressListTableViewCell: UITableViewCell {


    //名称
    @IBOutlet weak var addressName: UILabel!
        @IBOutlet weak var nameHeightLayout: NSLayoutConstraint!
    
    //位置
    
    @IBOutlet weak var mapTopLayout: NSLayoutConstraint!
    
    @IBOutlet weak var addressLocation: UILabel!
    
    //联系人
    
    @IBOutlet weak var contact: UILabel!
    //电话
    @IBOutlet weak var addressPhone: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.addressName.numberOfLines = 0
        self.addressLocation.numberOfLines = 0
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
