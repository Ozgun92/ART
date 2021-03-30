//
//  RegisterVC.swift
//  ART
//
//  Created by Özgün Yildiz on 28.03.21.
//

import UIKit
import Firebase


class RegisterVC: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var usernameTxt: UITextField!
    
    
    @IBOutlet weak var emailTxt: UITextField!
    
    @IBOutlet weak var passwordTxt: UITextField!
    
    @IBOutlet weak var confirmPasswordTxt: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var passCheckImage: UIImageView!
    
    
    @IBOutlet weak var confirmPassCheckImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        passwordTxt.addTarget(self, action: #selector(editingChanged), for: UIControl.Event.editingChanged)
        confirmPasswordTxt.addTarget(self, action: #selector(editingChanged), for: UIControl.Event.editingChanged)
        
    }
    
    @objc func editingChanged(_ textField: UITextField) {
        guard let passTxt = passwordTxt.text else { return }
        
        if textField == confirmPasswordTxt {
            passCheckImage.isHidden = false
            confirmPassCheckImage.isHidden = false
        } else {
            if passTxt.isEmpty {
                passCheckImage.isHidden = true
                confirmPassCheckImage.isHidden = true
                confirmPasswordTxt.text = ""
            }
        }
        
        if confirmPasswordTxt.text == passwordTxt.text {
            passCheckImage.image = UIImage(named: AppImages.greenCheck)
            confirmPassCheckImage.image = UIImage(named: AppImages.greenCheck)
        } else {
            passCheckImage.image = UIImage(named: AppImages.redCheck)
            confirmPassCheckImage.image = UIImage(named: AppImages.redCheck)
        }
    }
    
    
    @IBAction func registerClicked(_ sender: Any) {
        guard let email = emailTxt.text, email.isNotEmpty,
              let username = usernameTxt.text, username.isNotEmpty,
              let password = passwordTxt.text, password.isNotEmpty else { simpleAlert(title: "Error", message: "Please fill out all fields")
                    return
            }
        
        guard let confirmPassTxt = confirmPasswordTxt.text, confirmPassTxt == password else {
            simpleAlert(title: "Error", message: "Passwords do not match")
            return
        }
        
        
        activityIndicator.startAnimating()
        
        
        guard let authUser = Auth.auth().currentUser else {
            return
        }
        print("5")
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        authUser.link(with: credential) { (result, error) in
            if let error = error {
                debugPrint(error)
                self.handleFireAuthError(error: error)
                return
            }
            print("6")
            self.activityIndicator.stopAnimating()
            self.dismiss(animated: true, completion: nil)
        }
    }
}


