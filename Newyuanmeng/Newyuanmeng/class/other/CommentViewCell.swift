//
//  CommentViewCell.swift
//  huabi
//
//  Created by TeamMac2 on 16/9/8.
//  Copyright © 2016年 ltl. All rights reserved.
//

import UIKit
import SwiftyJSON

class CommentViewCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var star1: UILabel!
    @IBOutlet weak var star2: UILabel!
    @IBOutlet weak var star3: UILabel!
    @IBOutlet weak var star4: UILabel!
    @IBOutlet weak var star5: UILabel!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var time: UILabel!
//    @IBOutlet weak var size: UILabel!
    @IBOutlet weak var content: UILabel!
    
    @IBOutlet weak var saddf: UILabel!
    @IBOutlet weak var commentTop: NSLayoutConstraint!
    
    var starArr:Array<UILabel> = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.starArr = [self.star1,self.star2,self.star3,self.star4,self.star5]
        self.img.layer.cornerRadius = self.img.frame.size.width/2
        self.img.clipsToBounds = true
        // Initialization code
    }

    func setCommentInfo(_ info:JSON){
        img.hnk_setImageFromURL(URL: URL(string: CommonConfig.getImageUrl(info["avatar"].stringValue))! as NSURL, placeholder: UIImage(named: CommonConfig.userDefaultIcon))
        name.text = info["uname"].stringValue
        comment.text = info["content"].stringValue
        time.text = "评价时间 : " + info["comment_time"].stringValue
        let point = Int((info["point"].floatValue/100)*5)
        setStar(point)
        saddf.text = info["spec"].stringValue
        content.text = ""
    }
    
    func setStar(_ numb:NSInteger){
        for i in 0..<5 {
            let star = self.starArr[i]
            if i < numb {
                star.text = IconFontIconName.icon_star_yes.rawValue
                star.textColor = CommonConfig.MainYellowColor
            }else{
                star.text = IconFontIconName.icon_star_no.rawValue
                star.textColor = CommonConfig.MainFontBlackColor
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
