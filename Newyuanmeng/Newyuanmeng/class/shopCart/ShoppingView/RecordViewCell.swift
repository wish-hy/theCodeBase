//
//  RecordViewCell.swift
//  huabi
//
//  Created by TeamMac2 on 16/8/31.
//  Copyright © 2016年 ltl. All rights reserved.
//

import UIKit
import SwiftyJSON

class RecordViewCell: UITableViewCell {

    @IBOutlet weak var recordTitle: UILabel!
    @IBOutlet weak var recordText: UILabel!
    @IBOutlet weak var recordPoints: UILabel!
    @IBOutlet weak var recordTime: UILabel!
    
    func setInfo(_ info:JSON){
        recordTitle.text = "订单号" + info["order_no"].stringValue
        recordTime.text = info["time"].stringValue
        recordText.text = info["note"].stringValue
        recordPoints.text = info["amount"].stringValue
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
