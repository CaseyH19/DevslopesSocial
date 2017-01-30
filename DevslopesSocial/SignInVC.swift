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
import SwiftKeychainWrapper

class SignInVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTxt: FancyField!
    @IBOutlet weak var passwordTxt: FancyField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        emailTxt.delegate = self
        passwordTxt.delegate = self
        
    }
    
    //segues cannot happen in view did load
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            print("KC: ID found in keychain")
            performSegue(withIdentifier: "gotoFeed", sender: nil)
        }
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
                if let user = user {
                    let userData = ["provider": cred.provider]
                    
                    self.completeSignIn(id: user.uid, userData: userData)
                }
               
            }
        })
    }
    
    //signing in with email/account
    @IBAction func signInPressed(_ sender: Any) {
        
        if let email = emailTxt.text, let pass = passwordTxt.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: pass, completion: { (user, error) in
                if error == nil {
                    print("KC: Email user Authenticated with Firebase, Existing Account")
                    if let user = user {
                        let userData = ["provider": user.providerID]
                        self.completeSignIn(id: user.uid, userData: userData)
                    }
                    
                } else {
                    //let user = firebaseAuth.auth().currentUser
                    let credentials = FIREmailPasswordAuthProvider.credential(withEmail: email, password: pass)
                    
                    FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
                        if let errCode = FIRAuthErrorCode(rawValue: error!._code) {
                            
                            switch errCode {
                            case .errorCodeWrongPassword:
                                print("KC: invalid password")
                                let alert = UIAlertController(title: "Login Failure", message: "Invalid Password, Please Retry", preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "RETRY", style: UIAlertActionStyle.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                                self.passwordTxt.text = ""
                               
                            case .errorCodeTooManyRequests:
                                print("KC: TOO many requiests ")
                                let alert = UIAlertController(title: "Login Failure", message: "Login Failed. Too many requests", preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "RETRY", style: UIAlertActionStyle.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                                self.passwordTxt.text = ""
                                
                            default:
                                print("KC: Create User Error")
                                let alert = UIAlertController(title: "New User", message: "Are you a new User to DevslopeSocial?", preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: { pressed in
                                    print("KC: NEW USER - \(pressed)")
                                    FIRAuth.auth()?.createUser(withEmail: email, password: pass, completion: { (user, error1) in
                                        
                                        if error1 == nil {
                                    
                                            print("KC: User created EMail")
                                            if let user = user {
                                                let userData = ["provider": user.providerID]
                                                self.completeSignIn(id: user.uid, userData: userData)
                                            }
                                            
                                        }
                                        else if let erCode = FIRAuthErrorCode(rawValue: error1!._code) {
                                            
                                            switch erCode {
                                             
                                            case .errorCodeWeakPassword:
                                                let alert = UIAlertController(title: "Login Failure", message: "WEAK Password, Please Retry", preferredStyle: UIAlertControllerStyle.alert)
                                                alert.addAction(UIAlertAction(title: "RETRY", style: UIAlertActionStyle.default, handler: nil))
                                                self.present(alert, animated: true, completion: nil)
                                                self.passwordTxt.text = ""
                                                
                                            case .errorCodeInvalidEmail:
                                                let alert = UIAlertController(title: "Login Failure", message: "Not a Valid Email Address, Please Retry", preferredStyle: UIAlertControllerStyle.alert)
                                                alert.addAction(UIAlertAction(title: "RETRY", style: UIAlertActionStyle.default, handler: nil))
                                                self.present(alert, animated: true, completion: nil)
                                                self.passwordTxt.text = ""
                                                self.emailTxt.text = ""
                                    
                                            default:
                                               print("\(error)")
                                               self.passwordTxt.text = ""
                                               self.emailTxt.text = ""
                                            }
                                        }
                                        
                                        
                                    })
                                    
                                }))
                                
                                alert.addAction(UIAlertAction(title: "NO, RE-ENTER INFO", style: UIAlertActionStyle.default, handler: { pressed in
                                    
                                        print("KC: NOT A NEW USER - \(pressed)")
                                        self.passwordTxt.text = ""
                                        self.emailTxt.text = ""
                                    
                                }))
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                    })
                    
                    
                    
 
                }
            })
        }
    }
    
    
    //completes signIn feature and segues to next part of the app
    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("KC: Did save to keychain - \(keychainResult)")
        performSegue(withIdentifier: "gotoFeed", sender: nil)
    }
    
    
}

