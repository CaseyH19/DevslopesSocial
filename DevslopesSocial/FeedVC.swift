//
//  FeedVC.swift
//  DevslopesSocial
//
//  Created by Casey on 1/25/17.
//  Copyright © 2017 Casey. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableview: UITableView!
    
    var posts = [Post]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableview.delegate = self
        tableview.dataSource = self
        
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            //looks for any changes in database and instantly updates
            //print(snapshot.value)
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                //resets the posts array so duplicates are not made everytime the app is updated/opened
                self.posts = []
                
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                        
                    }
                }
            }
            
            self.tableview.reloadData()
            
        })
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //number of total cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        print("KC: \(post.caption)")
        
        
        return tableview.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
    }
    
    
    
    
    //signs out of the app and removes the keychain
    //remember with tap gestures on images to enable user interaction
    @IBAction func signOutPress(_ sender: AnyObject) {
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("KC: ID removed: \(keychainResult)")
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "backLogin", sender: nil)
        
    }
    
    
    
    
    

}
