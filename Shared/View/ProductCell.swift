//
//  ProductCell.swift
//  ART
//
//  Created by Özgün Yildiz on 01.04.21.
//

import UIKit
import Kingfisher

//. 1. Delegate Pattern: ProductCell is the Boss that delegates a task to its employee, the ProductsVC. The task is the display of the cells
// since our delegate is weak, we have to conform our protocol to a class type
protocol ProductCellDelegate: class {
    func productFavorited(product: Product)
}



class ProductCell: UITableViewCell {

    // MARK: - Outlets
    
    
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var productLbl: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var favoriteBtn: UIButton!
    
    // fresh reminder of retain cycles: Why are we using weak here? Because we want the ViewConroller that will be the delegate of the ProductCell, to have a weak connection to it. With this, we want to avoid strong reference cylces that cause memory leaks (instances of the ViewController or/and our ProductCell that can't be deallocated in memory)
    weak var delegate: ProductCellDelegate?
    private var product: Product!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    // we are passing the viewController as the delegate
    func configureCell(product: Product, delegate: ProductCellDelegate) {
        self.product = product
        // we have to set the viewController as the delegate
        self.delegate = delegate
        productLbl.text = product.name
        if let url = URL(string: product.imageUrl) {
            let placeholder = UIImage(named: AppImages.placeholder)
            productImg.kf.indicatorType = .activity
            let options: KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.2))]
            productImg.kf.setImage(with: url, placeholder: placeholder, options: options)
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        if let price = formatter.string(from: product.price as NSNumber) {
            productPrice.text = price
        }
        
        if UserService.favorites.contains(product) {
            // Favorite
            favoriteBtn.setImage(UIImage(named: AppImages.FilledStar), for: .normal)
        } else {
            favoriteBtn.setImage(UIImage(named: AppImages.EmptyStar), for: .normal)
        }
    }

    @IBAction func addToCartClicked(_ sender: Any) {
    }
    
    @IBAction func favoriteClicked(_ sender: Any) {
        // we are telling our delegate to execute the function productFavorited and pass in a product
        // we have to pass in a product, that is why we have to think about how we get one. Well, when configureCell gets called, a product is passed in. But without declaring a product in the scope of the class of the ProducCell, we don't have access to it. So, what we do, is on line 38 assign the product that was passed in configureCell to the product we declared in the scope of the class on line 29
        delegate?.productFavorited(product: product)
    }
    
    
    
}
