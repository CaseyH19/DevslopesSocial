//
//  RoundBtn.swift
//  DevslopesSocial
//
//  Created by Casey on 1/23/17.
//  Copyright © 2017 Casey. All rights reserved.
//

import UIKit

class RoundBtn: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        //how far spans out
        layer.shadowRadius = 5.0
        //how far blur goes for
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        
        imageView?.contentMode = .scaleAspectFit
        
    }

    //do it in this function as size is already calculated
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.frame.width/2
        
    }
    
    
}
