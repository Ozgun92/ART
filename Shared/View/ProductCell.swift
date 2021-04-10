//
//  ProductCell.swift
//  ART
//
//  Created by Özgün Yildiz on 01.04.21.
//

import UIKit
import Kingfisher

class ProductCell: UITableViewCell {

    // MARK: - Outlets
    
    
    @IBOutlet weak var productImg: UIImageView!
    
    
    @IBOutlet weak var productLbl: UILabel!
    
    
    @IBOutlet weak var productPrice: UILabel!
    
    
    @IBOutlet weak var favoriteBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    func configureCell(product: Product) {
   
        productLbl.text = product.name
        if let url = URL(string: product.imageUrl) {
            let placeholder = UIImage(named: "placeholder")
            productImg.kf.indicatorType = .activity
            let options: KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.2))]
            productImg.kf.setImage(with: url, placeholder: placeholder, options: options)
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        if let price = formatter.string(from: product.price as NSNumber) {
            productPrice.text = price
        }
    }

    @IBAction func addToCartClicked(_ sender: Any) {
    }
    
    @IBAction func favoriteClicked(_ sender: Any) {
    }
    
    
    
}
