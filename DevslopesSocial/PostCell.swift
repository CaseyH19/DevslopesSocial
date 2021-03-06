//
//  PostCell.swift
//  DevslopesSocial
//
//  Created by Casey on 1/30/17.
//  Copyright © 2017 Casey. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var like: UIImageView!
    
    var post: Post!
    var likeRef: FIRDatabaseReference!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTapsRequired = 1
        like.addGestureRecognizer(tap)
        like.isUserInteractionEnabled = true
 
        
    }

    //= nil gives default value of nil
    func configureCell(post: Post, img: UIImage? = nil) {
        //var profIMG: UIImage!
        
        self.post = post
        likeRef = DataService.ds.REF_USER_CURRENT.child("likes").child(post.postKey)
        
        self.caption.text = post.caption
        self.likesLbl.text = "\(post.likes)"
        
        let userRef = DataService.ds.REF_USERS.child(post.uid).child("info")
        userRef.observe(.value, with: { (snap) in
            if let value = snap.value as? Dictionary<String, AnyObject> {
                //print("\(value)")
                let username = value["username"] as! String
                
                print("KC: Username for post is: \(username)")
                self.userNameLbl.text = username
                
                if let profurl = value["profURL"] as? String {
                
                    if let img = FeedVC.imageCache.object(forKey: profurl as NSString) {
                        print("KC: Loaded profile image from cache")
                        self.profileImg.image = img
                    } else {
                        let ref = FIRStorage.storage().reference(forURL: profurl)
                        ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                            if error != nil {
                                print("KC: Unable to download profile image for FIRStorage")
                            } else {
                                print("KC: Profile Image downloaded from FIRStorage")
                                if let imgData = data {
                                    if let img = UIImage(data: imgData) {
                                        self.profileImg.image = img
                                        FeedVC.imageCache.setObject(img, forKey: profurl as NSString)
                                    }
                                }
                            }
                            
                        })
                    }
                }
            }
        })
        
    
        //if the image is already stored in the cache
        if img != nil {
            self.postImg.image = img
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
                            self.postImg.image = img
                            FeedVC.imageCache.setObject(img, forKey: post.imageURL as NSString)
                        }
                    }
                }
                
            })
        }
        
        
        likeRef.observeSingleEvent(of: .value, with: { (snapshot) in
            //if null
            if let _ = snapshot.value as? NSNull {
                self.like.image = UIImage(named: "empty-heart")
            } else {
                self.like.image = UIImage(named: "filled-heart")

            }
        })
        
    }

    
    func likeTapped(sender: UITapGestureRecognizer) {
        
        likeRef.observeSingleEvent(of: .value, with: { (snapshot) in
            //if null
            if let _ = snapshot.value as? NSNull {
                self.like.image = UIImage(named: "filled-heart")
                self.post.adjLikes(addLike: true)
                self.likeRef.setValue(true)
                
                
            } else {
                self.like.image = UIImage(named: "empty-heart")
                self.post.adjLikes(addLike: false)
                self.likeRef.removeValue()
                
            }
        })
        
    }
 
    
}
