//
//  AddEditCategoryVC.swift
//  ARTAdmin
//
//  Created by Özgün Yildiz on 04.04.21.
//

import UIKit
import FirebaseStorage
import Firebase

class AddEditCategoryVC: UIViewController {
    
    // MARK: - Outlets
    
    
    @IBOutlet weak var nameText: UITextField!
    
    @IBOutlet weak var categoryImg: RoundedImageView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var addBtn: UIButton!
    
    var categoryToEdit: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(imgTapped(_:)))
        tap.numberOfTapsRequired = 1
        categoryImg.isUserInteractionEnabled = true
        categoryImg.addGestureRecognizer(tap)
        
        // If we are editing, categoryToEdit will != nil
        if let category = categoryToEdit {
            nameText.text = category.name
            addBtn.setTitle("Save Changes", for: .normal)
            
            if let url = URL(string: category.imgUrl) {
                categoryImg.contentMode = .scaleAspectFill
                categoryImg.kf.setImage(with: url)
            }
        }
        
        
    }
    
    @objc func imgTapped(_ tap: UITapGestureRecognizer) {
        launchImgPicker()
    }

    @IBAction func addCategoryClicked(_ sender: Any) {
        activityIndicator.startAnimating()
        uploadImageThenDocument()
    }
    
    
    
    func uploadImageThenDocument() {

        guard let image = categoryImg.image, let categoryName = nameText.text, categoryName.isNotEmpty else { simpleAlert(title: "Error", message: "Must add category Image and name")
            return
        }

        // Step 1: Turn the image into Data

        guard let imageData = image.jpegData(compressionQuality: 0.2) else { return }

        // Step 2: Create a storage image reference -> A location in Firestorage for it to be stored

        let imageRef = Storage.storage().reference().child("/categoryImages/\(categoryName).jpg")


        // Step 3: Set the meta data

        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"

        // Step 4: Upload the data

        imageRef.putData(imageData, metadata: metaData) { (metaData, error) in
            if let error = error {
                self.handleError(error: error, message: "Unable to upload image")
                return
            }

            // Step 5: Once the image is uploaded, retrieve the download URL

            imageRef.downloadURL { (url, error) in
                if let error = error {
                    self.handleError(error: error, message: "Unable to retrieve image url.")
                    return
            }

                guard let url = url else { return }
                print(url)

                // Step 6: Upload new Category document in the Firestore categories collection
                self.uploadDocument(url: url.absoluteString)
            }
        }
    }

    func uploadDocument(url: String) {

        // we are doing it like this because we have to take into account whether we are modifying or creating a category
        var docRef: DocumentReference!
        var category = Category(name: nameText.text!, id: "", imgUrl: url, timeStamp: Timestamp())
        docRef = Firestore.firestore().collection("categories").document()
        category.id = docRef.documentID

        let data = Category.modelToData(category: category)
        docRef.setData(data, merge: true) { (error) in
            if let error = error {
                self.handleError(error: error, message: "Unable to upload new category to Firestore")
                return
        }
            self.navigationController?.popViewController(animated: true)
    }
}


        
        
    func handleError(error: Error, message: String) {
        debugPrint(error.localizedDescription)
        self.simpleAlert(title: "Error", message: message)
        self.activityIndicator.stopAnimating()
    }
}

extension AddEditCategoryVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func launchImgPicker() {
        let imagePicker = UIImagePickerController()
        // we set the delegate so the 2 methods below can be called and modified
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        categoryImg.contentMode = .scaleAspectFill
        categoryImg.image = image
        dismiss(animated: true, completion: nil)
    }
    // for the case if we cancel without selecting any image
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
}

