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
    var id: String
    let category: String
    let price: Double
    let productDescription: String
    let imageUrl: String
    let timeStamp: Timestamp
    let stock: Int

    
    
    
    init(name: String,
         id: String,
         category: String,
         price: Double,
         productDescription: String,
         imageUrl: String,
         timeStamp: Timestamp,
         stock: Int) {
        self.name = name
        self.id = id
        self.category = category
        self.price = price
        self.productDescription = productDescription
        self.imageUrl = imageUrl
        self.timeStamp = timeStamp
        self.stock = stock
    }
    
    
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
    
    
    static func modelToData(product: Product) -> [String: Any] {
        let data: [String: Any] = ["name":product.name,
                    "id": product.id,
                    "category": product.category,
                    "price": product.price,
                    "productDescription": product.productDescription,
                    "imageUrl": product.imageUrl,
                    "timeStamp": product.timeStamp,
                    "stock": product.stock]
        
        return data
    }
    
}
