//
//  Extensions.swift
//  ART
//
//  Created by Özgün Yildiz on 29.03.21.
//

import UIKit
import Firebase

extension String {
    var isNotEmpty: Bool {
        return !isEmpty
    }
}


extension UIViewController {
    func simpleAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
   
}









//func simpleAlert(title: String, message: String) {
//    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//    present(alert, animated: true, completion: nil)
//}
