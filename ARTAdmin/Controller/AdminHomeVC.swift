//
//  ViewController.swift
//  ARTAdmin
//
//  Created by Özgün Yildiz on 28.03.21.
//

import UIKit

class AdminHomeVC: HomeVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem?.isEnabled = false
        let addButton = UIBarButtonItem(title: "Add Category", style: .plain, target: self, action: #selector(addCategory))
        navigationItem.rightBarButtonItem = addButton

}

    @objc func addCategory() {
        // segue to the add category view
        performSegue(withIdentifier: Segues.ToAddEditCategory, sender: self)
    }


}


