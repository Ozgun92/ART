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
    let favorite: Bool
}
