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

class DataService {
    
    //creates the singleton
    static let ds = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("users")
    
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    
    var REF_POSTS: FIRDatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    
    //make sure to differential between db user and normal user
    //creates the user with the authentication code and then stores the provider
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        //new created child for new user
        //updateChildValues only adds to the child's "array"
        REF_USERS.child(uid).updateChildValues(userData)
        
    }
    
    
    
    
    
    
    
}
