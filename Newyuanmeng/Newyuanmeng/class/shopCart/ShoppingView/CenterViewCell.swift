//
//  CenterViewCell.swift
//  huabi
//
//  Created by TeamMac2 on 16/8/26.
//  Copyright © 2016年 ltl. All rights reserved.
//

import UIKit

class CenterViewCell: UITableViewCell {

    @IBOutlet weak var iconlbl: UILabel!
    @IBOutlet weak var textlbl: UILabel!
    @IBOutlet weak var contentlbl: UILabel!
    @IBOutlet weak var lbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        iconlbl.layer.cornerRadius = 2
        iconlbl.clipsToBounds = true
    }

    func setInfo(_ icon:String,text:String,iconColor:UIColor,contents:String = "")
    {
        iconlbl.text = icon
        iconlbl.backgroundColor = iconColor
        textlbl.text = text
        contentlbl.text = contents
        if contents == "" {
            textlbl.textColor = CommonConfig.MainFontBlackColor
            textlbl.font = UIFont.systemFont(ofSize: 13)
            lbl.isHidden = true
        }else{
            textlbl.textColor = CommonConfig.MainFontGrayColor
            textlbl.font = UIFont.systemFont(ofSize: 12)
            lbl.isHidden = false
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
