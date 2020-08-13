//
//  signupViewController.swift
//  BeirutTrackingApp
//
//  Created by SPEAKFLUENCE GLOBAL on 08/08/2020.
//  Copyright © 2020 Maya Bridgman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class signupViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    let storageRef = Storage.storage().reference()
    let databaseRef = Database.database().reference()

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var alreadyHaveAccount: UIButton!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var phoneNum: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    
    var ref: DatabaseReference!
    var imagePicker:UIImagePickerController!
    
    override func viewDidLoad() {
        ref = Database.database().reference()
        view.backgroundColor = .white
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true;
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.init(displayP3Red: 255, green: 255, blue: 255, alpha: 1)
        signupBtn.layer.cornerRadius = 20.0
        emailTextField.layer.cornerRadius = 15.0
        passwordTextField.layer.cornerRadius = 15.0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
              self.view.endEditing(true)
          }
    
    
    func isValidEmail(testStr:String) -> Bool {
             let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
             
             let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
             return emailTest.evaluate(with: testStr)
         }
    

    
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)}))
            self.present(alert, animated: true, completion: nil)
        }
    
    func validateFields() -> String? {
    
    // Check that all fields are filled in
    if firstName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        lastName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
        
        return "Please fill in all fields."
    }
        
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
        if Utilities.isPasswordValid(cleanedPassword) == false {
                // Password isn't secure enough
                return "Please make sure your password is at least 8 characters, contains a special character and a number."
            }
            
            return nil
        }
    
    
    func checker(){
        guard emailTextField.text != nil else{
            print("email issue")
            return
        }
        guard passwordTextField.text != nil else{
            print("password issue")
            return
        }
        guard firstName
            .text != nil else{
            print("password issue")
            return
        }
        guard lastName.text != nil else{
            print("password issue")
            return
        }
        guard phoneNum.text != nil else{
            print("password issue")
            return
        }
    }
    
    
    @IBAction func signUpPressed(_ sender: Any) {
        
        let email = isValidEmail(testStr: emailTextField.text!)
        if email == false{
            showAlert(title: "Error!", message: "this is not a valid email, please try again")
            emailTextField.text = ""}else{
        
                checker()
    
                let error = validateFields()
                
                if error != nil {
                    print("issue with fields \(error.debugDescription)")
                    // There's something wrong with the fields, show error message
                    showAlert(title: "error", message: "issue with fields - password should contain >8 characters, symbol, number")
                }else{
                    
                    let firstname = firstName.text!
                    let lastname = lastName.text!
                    let email = emailTextField.text!
                    let password = passwordTextField.text!
                    let phoneNumber = phoneNum.text!
                    
                
                    Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                    
                        if err != nil{
                            self.showAlert(title: "error", message: "error creating user - account already exists")
                            print("issue with fields \(String(describing: error?.debugDescription))")
                    }else{

                            self.ref.child("users").child(result!.user.uid).setValue(["email": email,"firstname": firstname, "lastname": lastname, "uid": result!.user.uid, "phone number": phoneNumber])
                            
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let transVC = storyboard.instantiateViewController(withIdentifier: "transViewController")as! transViewController
                            self.navigationController?.pushViewController(transVC, animated: true)
                            
                            if error != nil {
                                // Show error message
                                self.showAlert(title: "Error!", message: "Error saving user data")
                            }
                        }
                        }
                        
        
    }
        }
    }
    
    


    @IBAction func loginButton(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
        
        }
    
}



