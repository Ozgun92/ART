//
//  ProductsVC.swift
//  ART
//
//  Created by Özgün Yildiz on 01.04.21.
//

import UIKit
import Firebase

class ProductsVC: UIViewController {
    
    var products = [Product]()
    // the category that was passed from the HomeVC in the prepareForSegue. We are force unwrapping it because we can be sure it has a value
    var category: Category!
    var listener: ListenerRegistration!
    let db = Firestore.firestore()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: Identifiers.ProductCell, bundle: nil), forCellReuseIdentifier: Identifiers.ProductCell)
        snapShotListener()
    }
    
    
    func snapShotListener() {
        listener = db.products(category: category.id).addSnapshotListener({ (snap, error) in
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
            cell.configureCell(product: products[indexPath.item])
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














