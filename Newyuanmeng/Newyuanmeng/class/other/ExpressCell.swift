//
//  ExpressCell.swift
//  huabi
//
//  Created by TeamMac2 on 16/10/10.
//  Copyright © 2016年 ltl. All rights reserved.
//

import UIKit

class ExpressCell: UITableViewCell ,TTTAttributedLabelDelegate{

    
    @IBOutlet weak var top: UILabel!
    
    @IBOutlet weak var bottom: UILabel!
    
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var titlelbl: TTTAttributedLabel!
    
    @IBOutlet weak var timelbl: UILabel!
    
    typealias viewClick = (String)->Void
    var phoneClick:viewClick?
    
    func initSetting(_ text:String,time:String,phone:String,colors:UIColor){
        timelbl.text = time
        img.image = CommonConfig.changeImageWithColor(img.image!, color: CommonConfig.MainRedColor)
//        if phone == "" {
//            titlelbl.text = text
//        }else{
            titlelbl.delegate = self
            titlelbl.numberOfLines = 0
            titlelbl.verticalAlignment = .center
            titlelbl.lineSpacing = 4
            titlelbl.lineBreakMode = .byCharWrapping
            titlelbl.textColor = colors
            titlelbl.enabledTextCheckingTypes = NSTextCheckingAllTypes
            titlelbl.linkAttributes = NSDictionary.init(dictionary: [NSNumber.init(value: true as Bool):kCTUnderlineStyleAttributeName]) as! [AnyHashable: Any]
            titlelbl.setText(text) { (attString) -> NSMutableAttributedString! in
//                print("TTTAttributedLabel text",text)
                let range = (text as NSString).range(of: phone)
                attString?.addAttribute(kCTForegroundColorAttributeName as String, value: CommonConfig.MainBlueColor.cgColor, range: range)
                return attString
            }
            let range2 = (text as NSString).range(of: phone)
            titlelbl.addLink(toPhoneNumber: phone, with: range2)
//        }
    }
    
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWithPhoneNumber phoneNumber: String!) {
//        print("didSelectLinkWithPhoneNumber",phoneNumber)
        phoneClick?(phoneNumber)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titlelbl.text = ""
        timelbl.text = ""
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
