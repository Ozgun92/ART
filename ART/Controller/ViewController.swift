//
//  ViewController.swift
//  ART
//
//  Created by Özgün Yildiz on 28.03.21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
 
    override func viewDidAppear(_ animated: Bool) {
        let storyboard = UIStoryboard(name: "LoginStoryboard", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "loginVC")
        present(controller, animated: true, completion: nil)
    }
  
   
}

