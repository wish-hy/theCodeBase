//
//  CategoryViewCell.swift
//  huabi
//
//  Created by TeamMac2 on 16/8/29.
//  Copyright © 2016年 ltl. All rights reserved.
//

import UIKit

class CategoryViewCell: UITableViewCell ,CenterButtonDelegate{

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var textlbl: UILabel!

    @IBOutlet weak var imgH: NSLayoutConstraint!
    
    @IBOutlet weak var textH: NSLayoutConstraint!
    
    @IBOutlet weak var top1: NSLayoutConstraint!
    
    @IBOutlet weak var top2: NSLayoutConstraint!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgH.constant = 66*newScale
        top1.constant = 8*newScale
        top2.constant = 8*newScale
        textH.constant = 20*newScale
        textlbl.font = UIFont.systemFont(ofSize: 20*newScale)
        // Initialization code
    }

    func setCenterView(_ titles:String,icons:String){
        img.hnk_setImageFromURL(URL: URL(string: CommonConfig.getImageUrl(icons))! as NSURL, placeholder: UIImage(named: CommonConfig.imageDefaultName))
        textlbl.text = titles
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
