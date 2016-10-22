//
//  MpOrderListTableViewCell.swift
//  MusicShare
//
//  Created by poleness on 16/1/30.
//  Copyright © 2016年 poleness. All rights reserved.
//

import UIKit

class MpOrderListTableViewCell: UITableViewCell {

    //标题
    @IBOutlet weak var orderTitle: UILabel!
    
    //图片
    @IBOutlet weak var logoImage: UIImageView!
    
    
    //商家名称
    @IBOutlet weak var shopName: UILabel!
    
    //费用
    @IBOutlet weak var orderFee: UILabel!
    
    //时间
    @IBOutlet weak var timePeriod: UILabel!
    
    //订单状态
    @IBOutlet weak var orderState: UILabel!
    
    //地点
    @IBOutlet weak var location: UILabel!
    
    //距离
    @IBOutlet weak var distance: UILabel!
    
    //标签
    @IBOutlet weak var tagView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.logoImage.layer.cornerRadius = 4.0
        self.logoImage.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
