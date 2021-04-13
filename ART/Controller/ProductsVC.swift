//
//  ProductsVC.swift
//  ART
//
//  Created by Özgün Yildiz on 01.04.21.
//

import UIKit
import Firebase

class ProductsVC: UIViewController, ProductCellDelegate {

    
    
    var products = [Product]()
    // the category that was passed from the HomeVC in the prepareForSegue. We are force unwrapping it because we can be sure it has a value
    var category: Category!
    var listener: ListenerRegistration!
    let db = Firestore.firestore()
    var showFavorites = false
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: Identifiers.ProductCell, bundle: nil), forCellReuseIdentifier: Identifiers.ProductCell)
        snapShotListener()
    }
    
    
    func snapShotListener() {
        
        var ref: Query!
        // if showFavorites is true, it means the favoritesButton was clicked and the user wants to see all the images he or she has favorited
        if showFavorites {
            ref =
                // In this case, we want to grab the document of the logged in user, go into his subcollection of favorites and listen to changes there
                db.collection(FIRE_COLLECTION.users).document(UserService.user.id).collection(FIRE_COLLECTION.favorites)
        } else {
            // if the favoritesButton was not clicked and hence showFavorites is false, use the ref for the products in the category that was passed by the HomeVC and listen to changes
            ref = db.products(category: category.id)
        }
        
        listener = ref.addSnapshotListener({ (snap, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
            } else {
                snap?.documentChanges.forEach({ (change) in
                    let data = change.document.data()
                    let product = Product(data: data)
                    
                    switch change.type {
                    case .added:
                        self.caseAdded(change: change, product: product)
                    case .modified:
                        self.caseModified(change: change, product: product)
                    case .removed:
                        self.caseRemoved(change: change)
                    }
                })
            }
        })
    }
    // this is being called by the tapping on a star (favorited) in the ProductCell. The IBAcion's name's called favoriteClicked. With this function, we are letting the ProductsVC know if a product was favorited
    func productFavorited(product: Product) {
        if UserService.isGuest {
            self.simpleAlert(title: "Hey :)", message: "This is a user-only feature. Please create a registered user to take advantage of all features.")
            return
        }
        
        UserService.favoriteSelected(product: product)
        // we want to reload the tableView for that row
        // return index of the product passed in
        guard let index = products.firstIndex(of: product) else { return }
        // reload the tableView at this row. This is more efficient than reloadData, because we reload much less
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)

    }
    
    
    func caseAdded(change: DocumentChange, product: Product) {
        let index = Int(change.newIndex)
        products.insert(product, at: index)
        tableView.insertRows(at: [IndexPath(item: index, section: 0)], with: .fade)
    }
    
    func caseRemoved(change: DocumentChange) {
        let oldIndex = Int(change.oldIndex)
        products.remove(at: oldIndex)
        tableView.deleteRows(at: [IndexPath(item: oldIndex, section: 0)], with: .left)
    }
    
    func caseModified(change: DocumentChange, product: Product) {
        if change.oldIndex == change.newIndex {
            let index = Int(change.newIndex)
            products[index] = product
            tableView.reloadRows(at: [IndexPath(item: index, section: 0)], with: .none)
        } else {
            let oldIndex = Int(change.oldIndex)
            let newIndex = Int(change.newIndex)
            products.remove(at: oldIndex)
            products.insert(product, at: newIndex)
            tableView.moveRow(at: IndexPath(item: oldIndex, section: 0), to: IndexPath(item: newIndex, section: 0))
        }
    }
    
    
}

extension ProductsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.ProductCell, for: indexPath) as? ProductCell {
            // here, we are also setting the ProductsVC as the delegate
            cell.configureCell(product: products[indexPath.item], delegate: self)
            return cell
        }
        return UITableViewCell()
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // The productDetailVC can only be accessed through a click on a product in the productsVC. That is why we can force unwrap the product in the productDetailVC, because there HAS TO be a product once we are on the productDetailView
        let vc = ProductDetailVC()
        let selectedProduct = products[indexPath.row]
        // we have created an instance of product in the productDetailVC. We are setting the product we did select to the product in the productDetailVC. This is why we can be 100% that product will have a value in the productDetailVC
        vc.product = selectedProduct
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}














