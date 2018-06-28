//
//  OrderDetailCell.swift
//  huabi
//
//  Created by TeamMac2 on 16/9/12.
//  Copyright © 2016年 ltl. All rights reserved.
//

import UIKit
import SwiftyJSON

class OrderDetailCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var countlbl: UILabel!
    @IBOutlet weak var pricelbl: UILabel!
    @IBOutlet weak var sizelbl: UILabel!
    @IBOutlet weak var colorlbl: UILabel!
    @IBOutlet weak var cartIcon: UILabel!
    
    typealias viewClick = (NSInteger)->Void
    
    var buychoose:viewClick?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setDetailInfo(_ info:JSON){
        titlelbl.text = info["name"].stringValue
        img.hnk_setImageFromURL(URL: URL(string: CommonConfig.getImageUrl(info["img"].stringValue))! as NSURL, placeholder: UIImage(named: CommonConfig.imageDefaultName))
        countlbl.text = "x" + info["goods_nums"].stringValue
        pricelbl.text = info["goods_price"].stringValue
        sizelbl.isHidden = true
        colorlbl.isHidden = true
        cartIcon.text = IconFontIconName.icon_cart_panicbuy.rawValue
    }
    
    @IBAction func buyClick(_ sender: AnyObject) {
        buychoose?(self.tag)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
