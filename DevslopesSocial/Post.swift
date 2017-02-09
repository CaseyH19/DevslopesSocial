//
//  Post.swift
//  DevslopesSocial
//
//  Created by Casey on 1/30/17.
//  Copyright © 2017 Casey. All rights reserved.
//

import UIKit
import Firebase

class Post {
    private var _caption: String!
    private var _imageURL: String!
    private var _likes: Int!
    private var _uid: String!
    private var _user: String!
    private var _postKey: String!
    private var _postReference: FIRDatabaseReference!
    var userRef: FIRDatabaseReference!
    
    var caption: String {
        return _caption
    }
    
    var imageURL: String {
        return _imageURL
    }
    
    var likes: Int {
        return _likes
    }
    
    var postKey: String {
        return _postKey
    }
    
    var user: String {
        if _user == nil {
            return ""
        } else {
            return _user
        }
        
    }
    
    var uid: String {
        return _uid
    }
    
    //creating new post
    init(caption: String, imageURL: String, likes: Int, user: String) {
        self._caption = caption
        self._imageURL = imageURL
        self._likes = likes
        let userInfo = DataService.ds.REF_USER_CURRENT.child("info")
        userInfo.observeSingleEvent(of: .value, with: { (snap) in
            if let value = snap.value as? Dictionary<String, String> {
                self._user = value["username"]
                
            }
        })
    }
    
    //getting from firebase
    init(postKey: String, postData: Dictionary<String, AnyObject>) {
        self._postKey = postKey
        
        if let caption = postData["caption"] as? String{
            self._caption = caption
        }
        
        if let imageURL = postData["imageurl"] as? String{
            self._imageURL = imageURL
        }
        
        if let likes = postData["likes"] as? Int {
            self._likes = likes
        }
        
        if let postUser = postData["uid"] as? String {
            print("KC: uid for user of post \(postUser)")
            self._uid = postUser
            
        }
        
        _postReference = DataService.ds.REF_POSTS.child(_postKey)
        
    }
    
    func adjLikes(addLike: Bool) {
        if addLike {
            _likes = _likes + 1
            
            
        } else {
            _likes = likes - 1
        }
        
        
        _postReference.child("likes").setValue(_likes)
    }
    
    
}





