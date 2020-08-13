//
//  userViewControlleerr.swift
//  BeirutTrackingApp
//
//  Created by SPEAKFLUENCE GLOBAL on 10/08/2020.
//  Copyright © 2020 Maya Bridgman. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class userViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!

    var profileData: [String] = []
    let storageRef = Storage.storage().reference()
    var databaseRef = Database.database().reference()
    var ref: DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        print(ref)
        if ref == nil {
            print("ref is nil")
        }
        //let userID = Auth.auth().currentUser?.uid
        ref?.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            print("observeSingleEvent callback closure called")
            print(snapshot.value)
            let profile = snapshot.value as? String
            print(self.ref?.child("users"))
            if let actualProfile = profile {
                print("profile is not nil")
                self.profileData.append(actualProfile)
                print(self.profileData)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
            
                }
            } else { print("profile is not nil") }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Calculating number of rows in tableview: \(profileData.count)")
        return profileData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Getting cell at index: \(indexPath.row)")
        print("Cell text: \(self.profileData[indexPath.row])")
        let cell = tableView.dequeueReusableCell(withIdentifier: "firstName_cell", for: indexPath)
        cell.textLabel?.text = self.profileData[indexPath.row]
        return cell
    }
}
