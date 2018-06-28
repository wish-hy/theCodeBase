//
//  CollectViewCell.swift
//  huabi
//
//  Created by TeamMac2 on 16/9/2.
//  Copyright © 2016年 ltl. All rights reserved.
//

import UIKit

class CollectViewCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var titles: UILabel!
    @IBOutlet weak var prices: UILabel!
    @IBOutlet weak var delBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    
    typealias viewClick = (NSInteger)->Void
    
    var deleteClick:viewClick?
    var addClick:viewClick?
    
    @IBAction func addClick(_ sender: AnyObject) {
        addClick?(self.tag)
    }
    
    @IBAction func delClick(_ sender: AnyObject) {
        deleteClick?(self.tag)
    }
    
    func setCollectInfo(_ title:String,price:String,imgs:String){
        titles.text = title
        prices.text = "¥" + price
        img.hnk_setImageFromURL(URL: URL(string: CommonConfig.getImageUrl(imgs))! as NSURL, placeholder: UIImage(named: CommonConfig.imageDefaultName))
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        delBtn.setTitle(IconFontIconName.icon_delet_address.rawValue, for: UIControlState())
        addBtn.setTitle(IconFontIconName.icon_cart_collect.rawValue, for: UIControlState())
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
