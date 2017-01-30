//
//  CircleView.swift
//  DevslopesSocial
//
//  Created by Casey on 1/30/17.
//  Copyright © 2017 Casey. All rights reserved.
//

import UIKit

class CircleView: UIImageView {

    
    override func layoutSubviews() {
        
        layer.cornerRadius = self.frame.width/2
        clipsToBounds = true
        
    }

}
