
import UIKit

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class userTableViewController: UITableViewController {
    
    var profileData = [profileStruct]()
    let storageRef = Storage.storage().reference()
    var databaseRef = Database.database().reference()
    var ref: DatabaseReference?

     
     override func viewDidLoad() {
         super.viewDidLoad()
         getProfile()
         // Do any additional setup after loading the view.
         tableView.register(ProfileCell.self, forCellReuseIdentifier: "ProfileCell")
     }

     override func didReceiveMemoryWarning() {
         super.didReceiveMemoryWarning()
         // Dispose of any resources that can be recreated.
     }
     
     
     struct profileStruct {
         let email : String!
         let phoneNumber : String!
     }
     
    
    func getProfile() {
        let databaseRef = Database.database().reference()
        databaseRef.child("users").queryOrderedByKey().observeSingleEvent(of: .childAdded, with: {
                    snapshot in
                    let email = (snapshot.value as? NSDictionary)!["email"] as? String
                    let phoneNumber = (snapshot.value as? NSDictionary
                        )!["phone number"] as? String
                    self.profileData.append(profileStruct(email: email, phoneNumber: phoneNumber))
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                })
    }
    


     override func numberOfSections(in tableView: UITableView) -> Int {
         return 1
     }
     
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return profileData.count
     }
     
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell") as? ProfileCell else { return UITableViewCell() }
         cell.emailLabel?.text = profileData[indexPath.row].email
         print(profileData[indexPath.row].email)
         return cell
     }
}


