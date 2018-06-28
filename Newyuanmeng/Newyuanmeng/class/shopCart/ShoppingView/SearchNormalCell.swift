//
//  SearchNormalCell.swift
//  huabi
//
//  Created by TeamMac2 on 16/8/30.
//  Copyright © 2016年 ltl. All rights reserved.
//

import UIKit
import SwiftyJSON

class SearchNormalCell: UITableViewCell ,HBTagViewwDelegate{

    @IBOutlet weak var titles: UILabel!
    @IBOutlet weak var line: UILabel!
    
    var searchView: HBTagView!
    var isSet:Bool = false
    
    typealias viewClick = (NSInteger)->Void
    typealias stringClick = (NSString)->Void
    
    var tagClick:viewClick?
    var chooseClick:stringClick?
    var type = 0
    
    func setSearchInfo(_ info:Array<String>,types:NSInteger, flag:NSInteger = 0){
        if isSet {
            searchView.removeFromSuperview()
            isSet = false
        }
        type = types
        self.tag = flag
        searchView = HBTagView.init(frame: CGRect(x: 34*newScale, y: 42*newScale + 13, width: screenWidth - 68*newScale, height: CommonConfig.getCellHeight(info) + 5), tagInfo: info, type: types, delegate: self)
        searchView.backgroundColor = UIColor.white
        self.contentView.addSubview(searchView)
        isSet = true

    }
    
    func selectHBTagView(_ tag: NSInteger) {
        if type == 3{
            chooseClick?("\(self.tag)-\(tag)" as NSString)
        }else{
            tagClick?(tag)
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
  
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
