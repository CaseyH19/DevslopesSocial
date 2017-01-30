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

class FeedVC: UIViewController {

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    //signs out of the app and removes the keychain
    @IBAction func signOutPressed(_ sender: Any) {
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("KC: ID removed: \(keychainResult)")
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "backLogin", sender: nil)
        
    }
    
    
    
    
    

}
