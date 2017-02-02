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

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tableview: UITableView!
    var imagePicker: UIImagePickerController!
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    
    var posts = [Post]()
    
    @IBOutlet weak var addImg: CircleView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableview.delegate = self
        tableview.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
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
        let post = self.posts[indexPath.row]
        
        //sets up reusable cell
        if let cell = tableview.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            
            if let img = FeedVC.imageCache.object(forKey: post.imageURL as NSString)
            {
                cell.configureCell(post: post, img: img)
                return cell
            } else {
                cell.configureCell(post: post)
                return cell
            }
          
        } else {
            return PostCell()
        }

    }
    
    //after image is selected the imagepicker is dismissed
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            addImg.image = image
        } else {
            print("KC: No image was selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    //signs out of the app and removes the keychain
    //remember with tap gestures on images to enable user interaction
    @IBAction func signOutPress(_ sender: AnyObject) {
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("KC: ID removed: \(keychainResult)")
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "backLogin", sender: nil)
        
    }
    
    
    @IBAction func addImgPressed(_ sender: AnyObject) {
        print("KC: Getting Image")
        present(imagePicker, animated: true, completion: nil)
        
        
    }
    
    
    
    

}
