//
//  MsMyFollowTableViewCell.swift
//  MusicShare
//
//  Created by poleness on 15/12/15.
//  Copyright © 2015年 poleness. All rights reserved.
//

import UIKit

class MsMyFollowTableViewCell: UITableViewCell {

    //头像
    @IBOutlet weak var userPhoto: UIImageView!
    //名字
    @IBOutlet weak var userName: UILabel!
    
    //个性签名
    @IBOutlet weak var psSignLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.userPhoto.layer.cornerRadius = 22.0
        self.userPhoto.clipsToBounds = true
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
