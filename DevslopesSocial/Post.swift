//
//  Post.swift
//  DevslopesSocial
//
//  Created by Casey on 1/30/17.
//  Copyright © 2017 Casey. All rights reserved.
//

import UIKit

class Post {
    private var _caption: String!
    private var _imageURL: String!
    private var _likes: Int!
    private var _postKey: String!
    
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
    
    //creating new post
    init(caption: String, imageURL: String, likes: Int) {
        self._caption = caption
        self._imageURL = imageURL
        self._likes = likes
        
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
        
    }
    
}





