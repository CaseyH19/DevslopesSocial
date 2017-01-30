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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableview.delegate = self
        tableview.dataSource = self
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableview.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
    }
    
    
    
    
    //signs out of the app and removes the keychain
    @IBAction func signOutPress(_ sender: AnyObject) {
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("KC: ID removed: \(keychainResult)")
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "backLogin", sender: nil)
        
    }
    
    
    
    
    

}
