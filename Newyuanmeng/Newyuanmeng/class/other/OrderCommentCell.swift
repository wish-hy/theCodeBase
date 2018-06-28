//
//  OrderCommentCell.swift
//  huabi
//
//  Created by TeamMac2 on 16/9/12.
//  Copyright © 2016年 ltl. All rights reserved.
//

import UIKit

class OrderCommentCell: UITableViewCell {


 
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var commentBtn: UIButton!
    
    typealias viewClick = (Array<NSInteger>)->Void
    
    var imgClick:viewClick?
    var confirmClick:viewClick?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commentBtn.layer.cornerRadius = 5
        commentBtn.layer.borderColor = CommonConfig.MainYellowColor.cgColor
        commentBtn.layer.borderWidth = 1
        commentBtn.clipsToBounds = true
        // Initialization code
    }

    func setCellInfo(_ imgurl:String,titlename:String){
        self.img.hnk_setImageFromURL(URL: URL(string: CommonConfig.getImageUrl(imgurl))! as NSURL, placeholder: UIImage(named: CommonConfig.imageDefaultName))
        titlelbl.text = titlename
    }
    
    
    @IBAction func imgBtnClick(_ sender: AnyObject) {
        imgClick?([self.tag,sender.tag!])
    }
    
    @IBAction func commentClick(_ sender: UIButton) {
        confirmClick?([self.tag,sender.tag])
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
