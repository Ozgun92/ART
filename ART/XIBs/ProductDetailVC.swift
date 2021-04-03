//
//  ProductDetailVC.swift
//  ART
//
//  Created by Özgün Yildiz on 03.04.21.
//

import UIKit

class ProductDetailVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var productImg: UIImageView!
    
    @IBOutlet weak var productTitle: UILabel!
    
    @IBOutlet weak var productPrice: UILabel!
    
    @IBOutlet weak var productDescription: UILabel!
    
    
    @IBOutlet weak var bgView: UIVisualEffectView!
    
    var product: Product!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        productTitle.text = product.name
        productDescription.text = product.productDescription
        
        if let url = URL(string: product.imageUrl) {
            productImg.kf.setImage(with: url)
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        if let price = formatter.string(from: product.price as NSNumber) {
            productPrice.text = price
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissProduct(_:)))
        tap.numberOfTapsRequired = 1
        bgView.addGestureRecognizer(tap)
    }
 
   
    
    @objc func dismissProduct() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addToCartClicked(_ sender: Any) {
        // Add product to cart
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func dismissProduct(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    


}
