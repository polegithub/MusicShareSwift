//
//  MsGoodsAppraisalCell.swift
//  MusicShare
//
//  Created by poleness on 15/12/6.
//  Copyright © 2015年 poleness. All rights reserved.
//

import UIKit

class MsGoodsAppraisalCell: UITableViewCell {

    //User Photo
    @IBOutlet weak var userPhoto: UIImageView!
    
    //User name
    @IBOutlet weak var userName: UILabel!
    
    //User comment
    @IBOutlet weak var userComment: UILabel!
    
    //Comment time
    @IBOutlet weak var commentTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        self.userPhoto.layer.cornerRadius = 10.0
        self.userPhoto.clipsToBounds = true
        self.userComment.numberOfLines = 0

        // Configure the view for the selected state
    }
    
}
