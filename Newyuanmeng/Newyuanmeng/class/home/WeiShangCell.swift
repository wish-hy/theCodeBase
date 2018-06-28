//
//  WeiShangCell.swift
//  huabi
//
//  Created by teammac3 on 2017/12/22.
//  Copyright © 2017年 ltl. All rights reserved.
//

import UIKit
typealias AddCarBlock = ()->Void

class WeiShangCell: UITableViewCell {

    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var referenceLabel: UILabel!
    @IBOutlet weak var addCarButton: UIButton!
    var addCarBack: AddCarBlock?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func addCarAction(_ sender: Any) {
        if addCarBack != nil{
            self.addCarBack!()
        }
    }
    
    func callBackBlock(_ block: @escaping AddCarBlock) {
       self.addCarBack = block
    
    }
    
}
