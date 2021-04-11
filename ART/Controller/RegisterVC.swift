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
        
        //        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
        //            if let error = error {
        //                debugPrint(error)
        //                Auth.auth().handleFireAuthError(error: error, vc: self)
        //                return
        //            }
        //
        
        //
        //        }
        
        
        // this could be an anonymous user or a non-anonymour user (in both cases, an authenticated user)
        guard let authUser = Auth.auth().currentUser else {
            return
        }
        
        // we are creating a credential for the authUser, so that we can link an existing user, whether anonymous or not
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        authUser.link(with: credential) { (result, error) in
            if let error = error {
                debugPrint(error)
                Auth.auth().handleFireAuthError(error: error, vc: self)
                return
            }
            
            guard let firUser = result?.user else { return }
            // we want the UID from the authenticated user to be the id of the user in our user collection
            let artUser = User(id: firUser.uid, email: email, username: username, stripeId: "")
            // upload to Firestore
            self.createFirestoreUser(user: artUser)
            
        }
    }
    
    func createFirestoreUser(user: User) {
        let docRef = Firestore.firestore().collection("users").document(user.id)
        
        let userData = User.modelToData(user: user)
        
        docRef.setData(userData) { (error) in
            if let error = error {
                Auth.auth().handleFireAuthError(error: error, vc: self)
                debugPrint("Unable to upload new user document: \(error.localizedDescription)")
                return
            } else {
                self.dismiss(animated: true, completion: nil)
            }
            self.activityIndicator.stopAnimating()
        }
    }
}


