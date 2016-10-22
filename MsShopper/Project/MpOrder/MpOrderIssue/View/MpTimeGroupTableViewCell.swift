
//
//  MpTimeGroupTableViewCell.swift
//  MusicShare
//
//  Created by poleness on 16/1/27.
//  Copyright © 2016年 poleness. All rights reserved.
//

import UIKit

class MpTimeGroupTableViewCell: UITableViewCell {

    @IBOutlet weak var timeStartLabel: UILabel!
    
    @IBOutlet weak var timeEndLabel: UILabel!
    
    @IBOutlet weak var deadlineLabel: UILabel!
    
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
