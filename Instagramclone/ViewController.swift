//
//  ViewController.swift
//  Instagramclone
//
//  Created by Can Kanbur on 4.04.2023.
//

import UIKit
import FirebaseAuth
class ViewController: UIViewController {

    
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func signInClicked(_ sender: Any) {
        if emailText.text != "" && passwordText.text != "" {
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { data, error in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "error")
                }else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
                
            }
            
        }else{
            makeAlert(title: "Error", message: "Password/Username not empty")

        }
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        
        if emailText.text != "" && passwordText.text != "" {
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { data, error in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "error")
                }else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        }else{
            makeAlert(title: "Error", message: "Password/Username")
        }
        
      
    }
    func makeAlert(title:String,message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel)
        alert.addAction(okButton)
        present(alert,animated: true)
    }
}

