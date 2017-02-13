//
//  UserPostCell.swift
//  DevslopesSocial
//
//  Created by Casey on 2/9/17.
//  Copyright © 2017 Casey. All rights reserved.
//

import UIKit
import Firebase

class UserPostCell: UITableViewCell {

    
    @IBOutlet weak var postIMG: UIImageView!
    @IBOutlet weak var capt: UITextView!
    
    @IBOutlet weak var likeLbl: UILabel!
    
    var post: Post!
    
    

    func configureCell(post: Post, img: UIImage? = nil) {
        self.post = post
        
        self.capt.text = post.caption
        self.likeLbl.text = "\(post.likes)"

        
        if img != nil {
            self.postIMG.image = img
        } //file will be downloaded
        else {
            let ref = FIRStorage.storage().reference(forURL: post.imageURL)
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("KC: Unable to download image for FIRStorage")
                } else {
                    print("KC: Image downloaded from FIRStorage")
                    if let imgData = data {
                        if let img = UIImage(data: imgData) {
                            self.postIMG.image = img
                            FeedVC.imageCache.setObject(img, forKey: post.imageURL as NSString)
                        }
                    }
                }
                
            })
        }
    }
    

}
