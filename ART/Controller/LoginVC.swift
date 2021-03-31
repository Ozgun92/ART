//
//  LoginVC.swift
//  ART
//
//  Created by Özgün Yildiz on 28.03.21.
//

import UIKit
import Firebase

class LoginVC: UIViewController {

    
    @IBOutlet weak var emailTxt: UITextField!
    
    @IBOutlet weak var passTxt: UITextField!
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func forgotPassClicked(_ sender: Any) {
        let vc = ForgotPasswordVC()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func logInClicked(_ sender: Any) {
        
        guard let email = emailTxt.text, email.isNotEmpty, let password = passTxt.text, password.isNotEmpty else {
            simpleAlert(title: "Error", message: "Please fill out all fields")
            return
        }
    
        activityIndicator.startAnimating()
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                Auth.auth().handleFireAuthError(error: error, vc: self)
                self.activityIndicator.stopAnimating()
                return
            }
            self.activityIndicator.stopAnimating()
            self.dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    @IBAction func guestClicked(_ sender: Any) {
    }
    
}
