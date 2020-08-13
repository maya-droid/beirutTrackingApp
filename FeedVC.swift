//
//  FeedVC.swift
//  BeirutTrackingApp
//
//  Created by SPEAKFLUENCE GLOBAL on 13/08/2020.
//  Copyright © 2020 Maya Bridgman. All rights reserved.
//


import UIKit
import Firebase
import FirebaseDatabase
import SwiftKeychainWrapper

class FeedVC: UITableViewController {
    
    var currentUserImageUrl: String!
    var posts = [Post]()
    var selectedPost: Post!

    override func viewDidLoad() {
        super.viewDidLoad()
        getUsersData()
        getPosts()
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getUsersData(){
      let uid = KeychainWrapper.standard.string(forKey: "uid")
        Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value) { (snapshot) in
            if let postDict = snapshot.value as? [String : AnyObject] {
                self.currentUserImageUrl = postDict["userImg"] as! String
                self.tableView.reloadData()
            }
        }
    }
    
    func getPosts() {
        Database.database().reference().child("textPosts").observeSingleEvent(of: .value) { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else { return }
            self.posts.removeAll()
            for data in snapshot.reversed() {
                guard let postDict = data.value as? Dictionary<String, AnyObject> else { return }
                let post = Post(postKey: data.key, postData: postDict)
                self.posts.append(post)
            }
            self.tableView.reloadData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell") as? PostCell else { return UITableViewCell() }
        cell.configCell(post: posts[indexPath.row-1])
        return cell
    }



}

