//
//  DataService.swift
//  DevslopesSocial
//
//  Created by Casey on 1/30/17.
//  Copyright © 2017 Casey. All rights reserved.
//  Singleton is universally useable

import UIKit
import Firebase

let DB_BASE = FIRDatabase.database().reference()
//reference to database url
let STORAGE_BASE = FIRStorage.storage().reference()
//reference to storage

class DataService {
    
    //creates the singleton
    static let ds = DataService()
    
    //DB References
    private var _REF_BASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("users")
    
    //Storage References
    private var _REF_POST_IMAGES = STORAGE_BASE.child("post-pics")
    //private var _REF_USER_IMAGES = STORAGE_BASE.child("user-pics")
    
    
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    
    var REF_POSTS: FIRDatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    
    var REF_POST_IMAGES: FIRStorageReference {
        return _REF_POST_IMAGES
    }
    
    /*
    var REF_USER_IMAGES: FIRStorageReference {
        return _REF_USER_IMAGES
    }
    */    
 
    //make sure to differential between db user and normal user
    //creates the user with the authentication code and then stores the provider
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        //new created child for new user
        //updateChildValues only adds to the child's "array"
        REF_USERS.child(uid).updateChildValues(userData)
        
    }
    
    
    
    
    
    
    
}
