//
//  UserService.swift
//  ART
//
//  Created by Özgün Yildiz on 11.04.21.
//

import Foundation
import FirebaseAuth
import Firebase

let UserService = _UserService()

// This class fullfills multiple functions:
// - Tracking whether there are changes in user collections and fav-subcollections
// - For this purpose, creating and removing listeners
// - Setting the current User

final class _UserService {
    
    // Variables
    
    var user = User()
    var favorites = [Product]()
    let auth = Auth.auth()
    let db = Firestore.firestore()
    var userListener: ListenerRegistration? = nil
    var favsListener: ListenerRegistration? = nil
    
    var isGuest: Bool {
        // currentUser is the authenticated user in firestore, which may be anonymous or not
        
        guard let authUser = auth.currentUser else {
            
            return true
        }
        
        if authUser.isAnonymous {
            return true
        } else {
            return false
        }
    }// we know that we have saved the documents with the uid of the users
    
    func getCurrentUser() {
        
        guard let authUser = auth.currentUser else { return }
        
        // we want our snapshotListener to listen to this particular document
        let userRef = db.collection(FIRE_COLLECTION.users).document(authUser.uid)
        userListener = userRef.addSnapshotListener({ (snap, error) in
            
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            
            guard let data = snap?.data() else { return }
            self.user = User(data: data)
            print(self.user)
        })
  
        let favsRef = userRef.collection(FIRE_COLLECTION.favorites)
        favsListener = favsRef.addSnapshotListener({ (snap, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            
            snap?.documents.forEach({ (document) in
                let favorite = Product(data: document.data())
                self.favorites.append(favorite)
            })
        })
    }
    
    func favoriteSelected(product: Product) {
        let favesRef = Firestore.firestore().collection("users").document(user.id).collection("favorites")
        
        if favorites.contains(product) {
            // we remove it as a favorite
            favorites.removeAll{ $0 == product }
            favesRef.document(product.id).delete()
        } else {
            favorites.append(product)
            let data = Product.modelToData(product: product)
            favesRef.document(product.id).setData(data)
        }
    }
    
    func logoutUser() {
        userListener?.remove()
        userListener = nil
        favsListener?.remove()
        favsListener = nil
        user = User()
        favorites.removeAll()
    }
    
}
