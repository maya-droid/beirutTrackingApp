//
//  PostCellViewController.swift
//  BeirutTrackingApp
//
//  Created by SPEAKFLUENCE GLOBAL on 13/08/2020.
//  Copyright © 2020 Maya Bridgman. All rights reserved.
//


import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
import SwiftKeychainWrapper

import UIKit
import Firebase
import SwiftKeychainWrapper

class PostCell: UITableViewCell {
    
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var postText: UILabel!
    @IBOutlet weak var commentBtn: UIButton!
    
    var post: Post!
    let currentUser = KeychainWrapper.standard.string(forKey: "uid")
    
    func configCell(post: Post) {
        self.post = post
        self.username.text = post.username
        self.postText.text = post.postText
        
        let ref = Storage.storage().reference(forURL: post.userImg)
        ref.getData(maxSize: 100000000, completion: { (data, error) in
            if error != nil {
                print("couldnt load img")
            } else {
                if let imgData = data {
                    if let img = UIImage(data: imgData){
                        self.userImg.image = img
                    }
                }
            }
        })
    }
}
