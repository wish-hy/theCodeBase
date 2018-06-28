//
//  MessageViewCell.swift
//  huabi
//
//  Created by TeamMac2 on 16/9/2.
//  Copyright © 2016年 ltl. All rights reserved.
//

import UIKit

class MessageViewCell: UITableViewCell {

    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var contents: UILabel!
    
    @IBOutlet weak var textView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.layer.borderColor = CommonConfig.SliderBlackColor.cgColor
        textView.layer.borderWidth = 1
        // Initialization code
    }

    func setMessageInfo(_ titles:String,content:String,times:String){
        title.text = titles
        contents.text = content
        time.text = times
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
