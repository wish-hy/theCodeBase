//
//  ExpressDetailView.swift
//  huabi
//
//  Created by TeamMac2 on 16/10/10.
//  Copyright © 2016年 ltl. All rights reserved.
//

import UIKit

class ExpressDetailView: UIView {

    @IBOutlet weak var titlelbl: UILabel!
    
    @IBOutlet weak var img1: UIImageView!
    
    @IBOutlet weak var img2: UIImageView!
    
    @IBOutlet weak var btn: UIButton!
    
    typealias viewClick = (NSInteger)->Void
    typealias viewClick2 = (Array<NSInteger>)->Void
    
    var imgsClick:viewClick?
    var btnClick:viewClick2?
    
    @IBAction func showListClick(_ sender: UIButton) {
        btnClick?([self.tag,sender.tag])
        btnSelect(sender.tag)
    }
    
    @IBAction func imgClick(_ sender: UIButton) {
        imgsClick?(self.tag)
    }
    
    func btnSelect(_ type:NSInteger){
        if type > 0 {
            btn.setTitle("收起", for: UIControlState())
            btn.setTitleColor(UIColor.white, for: UIControlState())
            titlelbl.textColor = UIColor.white
            img2.image = CommonConfig.changeImageWithColor(UIImage.init(named: "shengxu")!, color: UIColor.white)
            self.backgroundColor = UIColor.init(hexCode: "FF0000")
        }else{
            btn.setTitle("展开", for: UIControlState())
            btn.setTitleColor(UIColor.init(hexCode: "FF0000"), for: UIControlState())
            titlelbl.textColor = UIColor.init(hexCode: "303030")
            img2.image = CommonConfig.changeImageWithColor(UIImage.init(named: "jiangxu")!, color: UIColor.init(hexCode: "8a8a8a"))
            self.backgroundColor = UIColor.init(hexCode: "efefef")
        }
        btn.tag = -type
    }
    
    func refreshColor(){
        btnSelect(-1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }

    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
