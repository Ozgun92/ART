//
//  Product.swift
//  ART
//
//  Created by Özgün Yildiz on 31.03.21.
//
import Firebase
import Foundation

struct Product {
    var name: String
    var id: String
    var category: String
    var price: Double
    var productDescription: String
    var imageUrl: String
    var timeStamp: Timestamp
    var stock: Int
    var favorite: Bool
}
