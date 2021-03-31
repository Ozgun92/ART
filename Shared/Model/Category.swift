//
//  Category.swift
//  ART
//
//  Created by Özgün Yildiz on 31.03.21.
//

import Foundation
import FirebaseFirestore

struct Category {
    var name: String
    var id: String
    var imgUrl: String
    var isActive: Bool = true
    var timeStamp: Timestamp
}
