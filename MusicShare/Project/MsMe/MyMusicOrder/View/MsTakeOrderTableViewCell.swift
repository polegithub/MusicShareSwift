//
//  MsTakeOrderTableViewCell.swift
//  MusicShare
//
//  Created by poleness on 16/1/5.
//  Copyright © 2016年 poleness. All rights reserved.
//

import UIKit

class MsTakeOrderTableViewCell: UITableViewCell {

    @IBOutlet weak var orderTitle: UILabel!
    
    //风格/标签
    @IBOutlet weak var styleView: UIView!
    
    //shop
    @IBOutlet weak var shopImage: UIImageView!
    
    @IBOutlet weak var shopName: UILabel!
    
    //time
    @IBOutlet weak var orderTime: UILabel!
    
    //place location
    @IBOutlet weak var location: UILabel!
    
    //people count
    @IBOutlet weak var peopleCount: UILabel!
    
    
    //price
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var acceptBtn: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //image
        self.shopImage.layer.cornerRadius = 22.5
        self.shopImage.clipsToBounds = true
        
        //内容
        self.orderTitle.textColor = UIColor.msCommonColor()
        
        //接单按钮
        self.acceptBtn .setTitleColor(UIColor.msCommonColor(), forState: UIControlState.Normal)
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
