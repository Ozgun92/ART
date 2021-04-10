//
//  User.swift
//  ART
//
//  Created by Özgün Yildiz on 10.04.21.
//

import Foundation

struct User {
    var id: String
    var email: String
    var username: String
    var stripeId: String
    
    
    init(id: String = "",
         email: String = "",
         username: String = "",
         stripeId: String = "") {
        self.id = id
        self.email = email
        self.username = username
        self.stripeId = stripeId
    }
    
}
