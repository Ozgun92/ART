//
//  Product.swift
//  ART
//
//  Created by Özgün Yildiz on 01.04.21.
//

import Foundation
import Firebase

struct Product {
    let name: String
    let id: String
    let category: String
    let price: Double
    let productDescription: String
    let imageUrl: String
    let timeStamp: Timestamp
    let stock: Int
    
    
    init(data: [String: Any]) {
        self.name = data["name"] as? String ?? ""
        self.id = data["id"] as? String ?? ""
        self.category = data["category"] as? String ?? ""
        self.price = data["price"] as? Double ?? 0
        self.productDescription = data["productDescription"] as? String ?? ""
        self.imageUrl = data["imageUrl"] as? String ?? ""
        self.timeStamp = data["timeStamp"] as? Timestamp ?? Timestamp()
        self.stock = data["stock"] as? Int ?? 0
    }
    
}
