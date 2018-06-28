//
//  InfoViewCell.swift
//  huabi
//
//  Created by TeamMac2 on 16/8/25.
//  Copyright © 2016年 ltl. All rights reserved.
//

import UIKit

class InfoViewCell: UITableViewCell {

    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var textlbl: UILabel!
    @IBOutlet weak var imgs: UIImageView!
    
    var type:Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgs.layer.cornerRadius = imgs.bounds.width / 2
        imgs.layer.masksToBounds = true
        // Initialization code
    }

    func setCellContent(_ titles:String,texts:String,images:UIImage, type:Int){
        self.textlbl.isHidden = false
        self.imgs.isHidden = false
        self.titlelbl.text = titles
        self.imgs.image = images
        if type == 0 {
            self.textlbl.isHidden = true
        }else if type == 1 {
            self.textlbl.text = texts
            self.imgs.isHidden = true
        }else if type == 2 {
            self.textlbl.isHidden = true
            self.imgs.isHidden = true
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
