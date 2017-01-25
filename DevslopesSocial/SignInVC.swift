//
//  ViewController.swift
//  DevslopesSocial
//
//  Created by Casey on 1/23/17.
//  Copyright © 2017 Casey. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class SignInVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTxt.delegate = self
        passwordTxt.delegate = self
        
        
        
        
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }

    @IBAction func fBookBtnPressed(_ sender: RoundBtn) {
        let facebookLogin = FBSDKLoginManager()
        //facebook authentication
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("KC: Unable to authenticate with Facebook -\(error)")
            }
            else if result?.isCancelled == true {
                print("KC: User cancelled authentication")
            }
            else {
                print("KC: Authenticated with Facebook")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
                
            }
        }
    }
    
    //firebase authentication method
    //make sure firebase authentication is set up for facebook login(under AUTH)
    func firebaseAuth(_ cred: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: cred, completion: { (user, error) in
            if error != nil {
                print("KC: Unable to authenticate with Firebase")
            } else {
                print("KC: Authenticated with Firebase")
                
            }
        })
    }
    
    
}

