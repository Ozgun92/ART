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
        let storyboard = UIStoryboard(name: Storyboard.loginStoryboard, bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: StoryboardId.loginVC)
        present(controller, animated: true, completion: nil)
    }
  
   
}

