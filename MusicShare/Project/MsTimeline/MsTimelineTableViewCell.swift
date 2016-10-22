//
//  MsTimelineTableViewCell.swift
//  MusicShare
//
//  Created by poleness on 15/12/7.
//  Copyright © 2015年 poleness. All rights reserved.
//

import UIKit

class MsTimelineTableViewCell: UITableViewCell {

    
    //头像
    @IBOutlet weak var userPhoto: UIImageView!
    
    //名字
    @IBOutlet weak var userName: UILabel!
    
    //时间
    @IBOutlet weak var sendTime: UILabel!
    
    //内容（状态/说说）
    @IBOutlet weak var userComment: UILabel!
    
    //外接音频/视频
    @IBOutlet weak var additionView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
