//
//  ImageCollectionCell.swift
//  huabi
//
//  Created by TeamMac2 on 16/9/14.
//  Copyright © 2016年 ltl. All rights reserved.
//

import UIKit

class ImageCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var img: UIImageView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        //self.imageView.
        //fatalError("init(coder:) has not been implemented")
    }
    
    override  init(frame: CGRect) {
        super.init(frame: frame)
        
    }
}
