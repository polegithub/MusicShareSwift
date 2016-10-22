//
//  MpMeCollectionViewCell.swift
//  MusicShare
//
//  Created by poleness on 16/1/19.
//  Copyright © 2016年 poleness. All rights reserved.
//

import UIKit

let meCollectionCellHeight:CGFloat = 90.0

class MpMeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageWidthLayout: NSLayoutConstraint!
    
    @IBOutlet weak var imageHeightLayout: NSLayoutConstraint!
    
    
    @IBOutlet weak var image: UIImageView!
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.backgroundColor = UIColor.msCommonColor()
        // Initialization code
    }

}
