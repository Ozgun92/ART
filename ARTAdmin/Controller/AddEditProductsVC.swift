//
//  AddEditProductsVC.swift
//  ARTAdmin
//
//  Created by Özgün Yildiz on 08.04.21.
//
import FirebaseStorage
import Firebase
import UIKit

class AddEditProductsVC: UIViewController {
    
    @IBOutlet weak var productNameTxt: UITextField!
   
    @IBOutlet weak var productPriceTxt: UITextField!
    
    
    @IBOutlet weak var productDescTxt: UITextView!
    
    
    @IBOutlet weak var productImgView: RoundedImageView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    @IBOutlet weak var addProductBtn: RoundedButton!
    
    var selectedCategory: Category!
    var productToEdit: Product?
    
    var name = ""
    var price = 0.0
    var productDescription = ""
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(imgTapped(_:)))
        tap.numberOfTapsRequired = 1
        productImgView.isUserInteractionEnabled = true
        productImgView.addGestureRecognizer(tap)
        
        if let product = productToEdit {
            productNameTxt.text = product.name
            productPriceTxt.text = String(product.price)
            productDescTxt.text = product.productDescription
            addProductBtn.setTitle("Save Changes", for: .normal)
            
            if let url = URL(string: product.imageUrl) {
                productImgView.contentMode = .scaleAspectFill
                productImgView.kf.setImage(with: url)
            }
        }
    }
    
    @objc func imgTapped(_ tap: UITapGestureRecognizer) {
        launchImgPicker()
    }
    

    @IBAction func addClicked(_ sender: Any) {
        
            guard let productName = productNameTxt.text, productName.isNotEmpty, let productPrice = productPriceTxt.text, let price = Double(productPrice), let productDescription = productDescTxt.text, productDescription.isNotEmpty, let productImg = productImgView.image else {
                simpleAlert(title: "Error", message: "Please fill in all fields")
                return
            }
        
        self.name = productName
        self.productDescription = productDescription
        self.price = price
        activityIndicator.startAnimating()
            
            guard let imageData = productImg.jpegData(compressionQuality: 0.2) else { return }
            
            let imageRef = Storage.storage().reference().child("/productImages/\(productName).jpg")
            
            
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpg"
            
            imageRef.putData(imageData, metadata: metaData) { (metaData, error) in
                if let error = error {
                    self.handleError(error: error, msg: "Unable to upload image.")
                    return
                }
                imageRef.downloadURL { (url, error) in
                    if let error = error {
                        self.handleError(error: error, msg: "Unable to download URL")
                        return
                    }
                    guard let url = url else { return }
                    self.uploadDocument(url: url.absoluteString)
                }
            }
            
        }
    
    func handleError(error: Error, msg: String) {
        debugPrint(error.localizedDescription)
        simpleAlert(title: "Error", message: msg)
        activityIndicator.stopAnimating()
    }
        
    func uploadDocument(url: String) {
        var documentReference: DocumentReference!
        
        var product = Product(name: name, id: "", category: selectedCategory.id, price: price, productDescription: productDescription, imageUrl: url, timeStamp: Timestamp(), stock: 0)
        
        if let productEdit = productToEdit {
            documentReference = Firestore.firestore().collection("products").document(productEdit.id)
            product.id = productEdit.id
        } else {
            documentReference = Firestore.firestore().collection("products").document()

            product.id = documentReference.documentID
           
        }
        
        let productData = Product.modelToData(product: product)
        
        documentReference.setData(productData, merge: true) { (error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            self.navigationController?.popViewController(animated: true)
        }
        
        }
        
       

}

extension AddEditProductsVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func launchImgPicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        productImgView.contentMode = .scaleAspectFill
        productImgView.image = image
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerDidCancel(_picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    

    
    
    
    
    
    
}
