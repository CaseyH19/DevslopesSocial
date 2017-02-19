//
//  ProfileVC.swift
//  DevslopesSocial
//
//  Created by Casey on 2/6/17.
//  Copyright © 2017 Casey. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class ProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var mainNameLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var originLbl: UILabel!
    @IBOutlet weak var birthdayLbl: UILabel!
    @IBOutlet weak var descText: UITextView!
    @IBOutlet weak var profilePic: UIImageView!
    
    
    @IBOutlet weak var tableview: UITableView!
    
    var userDataRef: FIRDatabaseReference!
    
    var posts = [Post]()
    
    var userpost = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        
        userDataRef = DataService.ds.REF_USER_CURRENT.child("info")
        //print("KC: \(userDataRef)")
        userDataRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value as? Dictionary<String, AnyObject> {
                USERNAME = value["username"] as! String
                USER = value["name"] as! String
                self.usernameLbl.text = USERNAME
                self.nameLbl.text = USER
                self.mainNameLbl.text = USERNAME
                
                self.birthdayLbl.text = value["birthday"] as? String
                self.originLbl.text = value["origin"] as? String
                self.descText.text = value["description"] as? String
                
                if let prURL = value["profURL"] as? String {
                    
                    if let img = FeedVC.imageCache.object(forKey: prURL as NSString) {
                        print("KC: Loaded profile image from cache")
                        self.profilePic.image = img
                    } else {
                        let ref = FIRStorage.storage().reference(forURL: prURL)
                        ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                            if error != nil {
                                print("KC: Unable to download profile image for FIRStorage")
                            } else {
                                print("KC: Profile Image downloaded from FIRStorage")
                                if let imgData = data {
                                    if let img = UIImage(data: imgData) {
                                        self.profilePic.image = img
                                        FeedVC.imageCache.setObject(img, forKey: prURL as NSString)
                                    }
                                }
                            }
                            
                        })
                    }
                }
            }
        })
        
        let userP = DataService.ds.REF_USER_CURRENT.child("posts")
        userP.observeSingleEvent(of: .value, with: { (snap) in
            if let value = snap.value as? Dictionary<String, AnyObject> {
                //print(value)
                for post in value {
                    //print(post.key)
                    self.userpost.append(post.key)
                }
                
                DataService.ds.REF_POSTS.observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    
                    if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                        self.posts = []
                        for snap in snapshot {
                            //print("SNAP: \(snap)")
                            
                            if let postDict = snap.value as? Dictionary<String, AnyObject> {
                                let key = snap.key
                                print("KC: \(key)")
                                
                                for x in 0..<self.userpost.count {
                                    //print(self.userpost[x])
                                    if self.userpost[x] == key {
                                        let post = Post(postKey: key, postData: postDict)
                                        self.posts.append(post)
                                        print("KC: Found user post")
                                    }
                                    
                                }
                            }
                        }
                    }
                    
                    self.tableview.reloadData()
                    
                })
            }
        })
        
        
        
        
        
        
    }

    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //return tableview.dequeueReusableCell(withIdentifier: "UserPostCell") as! UserPostCell
        
        let post = self.posts[indexPath.row]
        
        //sets up reusable cell
        if let cell = tableview.dequeueReusableCell(withIdentifier: "UserPostCell") as? UserPostCell {
            
            if let img = FeedVC.imageCache.object(forKey: post.imageURL as NSString)
            {
                cell.configureCell(post: post, img: img)
                return cell
            } else {
                cell.configureCell(post: post)
                return cell
            }
            
        } else {
            return UserPostCell()
        }
        

    }
    

}
