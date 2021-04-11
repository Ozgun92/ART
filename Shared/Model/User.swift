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
    
    
    init(data: [String: Any]) {
        // we are accessing the value of data["id"]. Id here is the key. And since it is of type "Any" and our model - id has a type of string, we have to downcast it to a String. Remember: as? is downcasting, as! is forced downcast, and as is upcast. Since a optional downcast can return nil, we unwrap it with nil coaelescing. The use of self is redundant here, but is used to preserve consistency
        self.id = data["id"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.username = data["username"] as? String ?? ""
        self.stripeId = data["stripeId"] as? String ?? ""
        
    }
    
    static func modelToData(user: User) -> [String: Any] {
        let data = [
            "id": user.id,
            "email": user.email,
            "username": user.username,
            "stripeId": user.stripeId
        ]
        
        return data
    }
    
}
