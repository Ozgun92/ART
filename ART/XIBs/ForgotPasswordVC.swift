//
//  ForgotPasswordVC.swift
//  ART
//
//  Created by Özgün Yildiz on 30.03.21.
//

import UIKit
import Firebase

class ForgotPasswordVC: UIViewController {
    
    @IBOutlet weak var forgotPwLbl: UILabel!
    
    @IBOutlet weak var emailTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resetPw(_ sender: Any) {
        guard let email = emailTF.text, email.isNotEmpty else {
            simpleAlert(title: "Error", message: "Please enter your email")
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                debugPrint(error)
                Auth.auth().handleFireAuthError(error: error, vc: self)
                return
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
}
