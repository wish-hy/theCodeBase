//
//  AddressViewCell.swift
//  huabi
//
//  Created by TeamMac2 on 16/9/2.
//  Copyright © 2016年 ltl. All rights reserved.
//

import UIKit

class AddressViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address1: UILabel!
    @IBOutlet weak var address2: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var using: UILabel!
    @IBOutlet weak var delBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    
    typealias viewClick = (NSInteger)->Void
    
    var deleteClick:viewClick?
    var editingClick:viewClick?

    
    func setCellInfo(_ names:String,addr1:String,addr2:String,numb:String, isUsing:Bool = false){
        name.text = names
        address1.text = addr1
        address2.text = addr2
        if MySDKHelper.isMobile(numb) {
            phone.text = (numb as NSString).substring(to: 3) + "******" + (numb as NSString).substring(from: 9)
        }else{
            phone.text = numb
        }
        using.isHidden = !isUsing
    }
    
    @IBAction func editClick(_ sender: UIButton) {
        editingClick?(self.tag)
    }
    
    @IBAction func delClick(_ sender: UIButton) {
        deleteClick?(self.tag)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        using.layer.cornerRadius = 10
        using.clipsToBounds = true
        delBtn.setTitle(IconFontIconName.icon_delet_address.rawValue, for: UIControlState())
        editBtn.setTitle(IconFontIconName.icon_goods_edit.rawValue, for: UIControlState())
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
