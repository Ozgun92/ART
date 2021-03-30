//
//  ViewController.swift
//  ART
//
//  Created by Özgün Yildiz on 28.03.21.
//

import UIKit
import Firebase

class HomeVC: UIViewController {
    
    // MARK: - Outlets
    
    
    @IBOutlet weak var loginOutBtn: UIBarButtonItem!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // there is NEITHER an anonymous, nor a non-anonymour logged in user
        if Auth.auth().currentUser == nil {
            Auth.auth().signInAnonymously { (result, error) in
                if let error = error {
                    debugPrint(error.localizedDescription)
                    self.handleFireAuthError(error: error)
                } else {
                    print("Signed in Anonymous user")
                }
            }
        }
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if let user = Auth.auth().currentUser, !user.isAnonymous {
            loginOutBtn.title = "Logout"
        } else {
            loginOutBtn.title = "Login"
        }
    }
    
    
    fileprivate func presentLoginController() {
        let storyboard = UIStoryboard(name: Storyboard.loginStoryboard, bundle: nil)
        let loginVC = storyboard.instantiateViewController(identifier: StoryboardId.loginVC)
        present(loginVC, animated: true, completion: nil)
    }
    
    
    
    @IBAction func loginOutClicked(_ sender: Any) {
        
        guard let user = Auth.auth().currentUser else { return }
        if user.isAnonymous {
            presentLoginController()
        } else {
            do {
                // we sign the current non-anonymous user out
                try Auth.auth().signOut()
                // and sign an anonymous user in, so the next time we start the app, the anonymous user will still be signed in
                Auth.auth().signInAnonymously { (result, error) in
                    if let error = error {
                        debugPrint(error)
                        self.handleFireAuthError(error: error)
                    }
                    self.presentLoginController()
                }
            } catch {
                debugPrint(error)
                self.handleFireAuthError(error: error)
            }
        }
        
    }

}

