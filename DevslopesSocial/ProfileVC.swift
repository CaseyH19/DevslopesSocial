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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        
        userDataRef = DataService.ds.REF_USER_CURRENT.child("info")
        //print("KC: \(userDataRef)")
        userDataRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? Dictionary<String, AnyObject>
            USERNAME = value?["username"] as! String
            USER = value?["name"] as! String
            self.usernameLbl.text = USERNAME
            self.nameLbl.text = USER
            self.mainNameLbl.text = USERNAME
            
            self.birthdayLbl.text = value?["birthday"] as? String
            self.originLbl.text = value?["origin"] as? String
            self.descText.text = value?["description"] as? String
        
        })
        
        
    }

    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return posts.count
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return PostCell()
        
    }
    

}
