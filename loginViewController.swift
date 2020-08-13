//
//  loginViewController.swift
//  BeirutTrackingApp
//
//  Created by SPEAKFLUENCE GLOBAL on 08/08/2020.
//  Copyright © 2020 Maya Bridgman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class loginViewController: UIViewController {

    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true;
        // Do any additional setup after loading the view.
        loginButton.layer.cornerRadius = 20.0
        emailField.layer.cornerRadius = 15.0
        passwordField.layer.cornerRadius = 15.0
        
    }
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    //MARK selectors
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           self.view.endEditing(true)
       }
    
    func emailFieldShouldReturn(_ textfield: UITextField) ->Bool{
        emailField.resignFirstResponder()
        
        return true
    }
    
    
    func handleLogin(){
        guard let email = self.emailField.text else {return}
        guard let password = self.passwordField.text else {return}
        
        logUserIn(withEmail: email, password: password)
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil{
                print("Failed to sign user in \(error.debugDescription)")
                self.showAlert(title: "error", message: "error, try again")
                return
            }
            print("Successfully signed in...")
            
        }
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
  
    func logUserIn(withEmail email: String, password: String){
        
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        let email = isValidEmail(testStr: emailField.text!)
        if email == false{
            showAlert(title: "Error!", message: "this is not a valid email, please try again")
            emailField.text = ""} else{
            
            
        guard let email = self.emailField.text else {return}
        guard let password = self.passwordField.text else {return}
        
        logUserIn(withEmail: email, password: password)
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil{
                print("Failed to sign user in \(error.debugDescription)")
                self.showAlert(title: "Error!", message: "incorrect email")
                return
            }
            print("Successfully signed in...")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let transVC = storyboard.instantiateViewController(withIdentifier: "transViewController")as! transViewController
            self.navigationController?.pushViewController(transVC, animated: true)
        
    }
        }
    }
    
    
    @IBAction func createAccountButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signupVC = storyboard.instantiateViewController(withIdentifier: "signupViewController")as! signupViewController
        self.navigationController?.pushViewController(signupVC, animated: true)
}
}

