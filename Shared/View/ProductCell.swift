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
            productImg.kf.setImage(with: url)
        }
    }

    @IBAction func addToCartClicked(_ sender: Any) {
    }
    
    @IBAction func favoriteClicked(_ sender: Any) {
    }
    
    
    
}
