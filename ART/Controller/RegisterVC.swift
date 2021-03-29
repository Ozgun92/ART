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
            passCheckImage.image = UIImage(named: "green_check")
            confirmPassCheckImage.image = UIImage(named: "green_check")
        } else {
            passCheckImage.image = UIImage(named: "red_check")
            confirmPassCheckImage.image = UIImage(named: "red_check")
        }
    }
    
    
    
    

    @IBAction func registerClicked(_ sender: Any) {
        guard let emailString = emailTxt.text, emailString.isNotEmpty else { return }
        guard let passwordString = passwordTxt.text, passwordString.isNotEmpty else { return }
        guard let confirmPasswordTextString = confirmPasswordTxt.text, confirmPasswordTextString.isNotEmpty else { return }
        guard passwordString == confirmPasswordTextString else { return }
        
        activityIndicator.startAnimating()
        
        Auth.auth().createUser(withEmail: emailString, password: passwordString) { (result, error) in
            if let error = error {
                debugPrint(error)
                return
            }
            self.activityIndicator.stopAnimating()
            print("Successfully registered new user")
        }
        }
    

    }
    


