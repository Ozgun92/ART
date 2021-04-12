//
//  Constants.swift
//  ART
//
//  Created by Özgün Yildiz on 29.03.21.
//

import Foundation
import UIKit

struct Storyboard {
    static let loginStoryboard = "LoginStoryboard"
    static let main = "Main"
}

struct StoryboardId {
    static let loginVC = "loginVC"
}

struct AppImages {
    static let greenCheck = "green_check"
    static let redCheck = "red_check"
    static let FilledStar = "filled_star"
    static let EmptyStar = "empty_star"
    static let placeholder = "placeholder"
}

struct AppColors {
    static let Blue = #colorLiteral(red: 0.2914361954, green: 0.3395442367, blue: 0.4364506006, alpha: 1)
    static let Red = #colorLiteral(red: 0.8739202619, green: 0.4776076674, blue: 0.385545969, alpha: 1)
    static let OffWhite = #colorLiteral(red: 0.9626371264, green: 0.959995091, blue: 0.9751287103, alpha: 1)
}

struct Identifiers {
    static let CategoryCell = "CategoryCell"
    static let ProductCell = "ProductCell"
}

struct Segues {
    static let ToProducts = "toProductsVC"
    static let ToAddEditCategory = "ToAddEditCategory"
    static let ToEditCategory = "ToEditCategory"
    static let ToAddEditProduct = "ToAddEditProduct"
    static let ToFavorites = "toFavorites"
}

struct Log {
    static let USER_LOGIN = "login"
    static let USER_LOGOUT = "logout"
}

struct FIRE_COLLECTION {
    static let users = "users"
    static let products = "products"
    static let categories = "categories"
    static let favorites = "favorites"
}
