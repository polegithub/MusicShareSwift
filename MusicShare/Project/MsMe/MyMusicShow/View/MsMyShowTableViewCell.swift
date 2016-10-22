//
//  MsMyShowTableViewCell.swift
//  MusicShare
//
//  Created by poleness on 15/12/14.
//  Copyright © 2015年 poleness. All rights reserved.
//

import UIKit

class MsMyShowTableViewCell: UITableViewCell {

    @IBOutlet weak var showImg: UIImageView!
    
    @IBOutlet weak var showTitle: UILabel!
    
    //歌手信息
    @IBOutlet weak var singerView: UIView!
    
    @IBOutlet weak var singerLabel: UILabel!
    
    //时间信息
    @IBOutlet weak var timeView: UIView!
    
    @IBOutlet weak var timeLabel: UILabel!
    //位置信息
    @IBOutlet weak var locationView: UIView!
    
    @IBOutlet weak var locationLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
