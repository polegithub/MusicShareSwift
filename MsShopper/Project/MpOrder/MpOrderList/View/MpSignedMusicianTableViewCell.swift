//
//  MpSignedMusicianTableViewCell.swift
//  MusicShare
//
//  Created by poleness on 16/2/26.
//  Copyright © 2016年 poleness. All rights reserved.
//

import UIKit

class MpSignedMusicianTableViewCell: UITableViewCell {

    //enter subview button
    @IBOutlet weak var enterSubBtn: UIButton!
    
    //photo image
    @IBOutlet weak var photoImage: UIImageView!
    
    //musician name
    @IBOutlet weak var musicianName: UILabel!
    
    //star view
    @IBOutlet weak var startBackView: UIView!
    
    
    //musician tag 标签，认证
    @IBOutlet weak var tagView: UIView!
    
    //action button
    @IBOutlet weak var chooseBtn: UIButton!
    
    @IBOutlet weak var removeBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
