//
//  CategoryTwoCell.swift
//  huabi
//
//  Created by TeamMac2 on 16/8/29.
//  Copyright © 2016年 ltl. All rights reserved.
//

import UIKit
import SwiftyJSON

class CategoryTwoCell: UITableViewCell ,HBTagViewwDelegate{
    
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var titlelbl: UILabel!
    var tagView: HBTagView!

    typealias viewClick = (String)->Void
    var selectClick:viewClick?
    
    var isSet:Bool = false
    var infos:JSON!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        // Initialization code
    }

    func setTagView(_ info:JSON){
        self.infos = info
        if isSet {
            tagView.removeFromSuperview()
            isSet = false
        }
        lbl.layer.cornerRadius = lbl.frame.size.width/2
        lbl.clipsToBounds = true
        titlelbl.text = info["title"].stringValue
        titlelbl.font = UIFont.systemFont(ofSize: 13)
        var arr:Array<String> = []
        for i in 0..<info["child"].count {
            arr.append(info["child"][i]["title"].stringValue)
        }
        tagView = HBTagView.init(frame: CGRect(x: 40*newScale, y: 64, width: screenWidth - 240*newScale, height: CommonConfig.getCellHeight(arr)), tagInfo: arr, type: 1, delegate: self)
        tagView.backgroundColor = UIColor.white
        self.contentView.addSubview(tagView)
        isSet = true
        
    }
    
    func selectHBTagView(_ tag: NSInteger) {
        selectClick?(self.infos["child"][tag]["id"].stringValue)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
