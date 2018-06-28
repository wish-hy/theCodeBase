//
//  SearchResultCell.swift
//  huabi
//
//  Created by TeamMac2 on 16/8/30.
//  Copyright © 2016年 ltl. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var comment: UILabel!
    
    @IBOutlet weak var textlbl: UILabel!
    
    func setInfo(_ info:GoodsModel){
        titlelbl.text = info.name
        comment.text = info.review_count + "人评价(" + info.satisfaction_rate + "好评)"
        price.text = "¥" + info.market_price
        textlbl.text = info.subtitle
        img.hnk_setImageFromURL(URL: URL(string: CommonConfig.getImageUrl(info.img))! as NSURL, placeholder: UIImage(named: CommonConfig.imageDefaultName))
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
