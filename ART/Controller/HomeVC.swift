//
//  ViewController.swift
//  ART
//
//  Created by Özgün Yildiz on 28.03.21.
//

import UIKit
import Firebase

class HomeVC: UIViewController {
    
    // MARK: - Outlets
    
    
    @IBOutlet weak var loginOutBtn: UIBarButtonItem!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    
    // MARK: - Categories
    
    let db = Firestore.firestore()
    // we are getting the selectedCategory in didSelectItemAt
    var selectedCategory: Category!
    var categories = [Category]()
    var listener: ListenerRegistration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupInitialAnonymousUser()
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        guard let font = UIFont(name: "futura", size: 26) else { return }
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: font
        ]
    }
    
    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: Identifiers.CategoryCell, bundle: nil), forCellWithReuseIdentifier: Identifiers.CategoryCell)
    }
    
    
    func setupInitialAnonymousUser() {
        if Auth.auth().currentUser == nil {
            Auth.auth().signInAnonymously { (result, error) in
                if let error = error {
                    debugPrint(error.localizedDescription)
                    Auth.auth().handleFireAuthError(error: error, vc: self)
                } else {
                    print("Signed in Anonymous user")
                }
            }
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        setCategoriesListener()
        if let user = Auth.auth().currentUser, !user.isAnonymous {
            loginOutBtn.title = Log.USER_LOGOUT
            
            // since viewWillAppear will be called every time the view will appear on screen (DUH), we could make the mistake to add a listener every time we open the HomeVC, if we call UserService.getCurrentUser. The function of the singleton creates 2 (one for user and one for favs) listeners every time it is called. This is why we are checking first if there is a user (which would mean there is also a favsListener, but it'd be redundant to check for it too), and if there is none, we want to create them (user and favs).
            // also, notice how easily we can use the UserService here (due to it being a global singleton)
            // also, notice the place where we are calling this function; Reason it is best here, is because after we have logged in, this view (HomeVC) will be shown. Every change to the users or favs collection can start here earliest
            if UserService.userListener == nil {
                UserService.getCurrentUser()
            }
        } else {
            loginOutBtn.title = Log.USER_LOGIN
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        listener.remove()
        categories.removeAll()
        collectionView.reloadData()
    }
    
    func setCategoriesListener() {
        
        listener = db.categories.addSnapshotListener({ (snap, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            // documentChanges is the array of the documents that changed since the last snapshot
            snap?.documentChanges.forEach({ (change) in
                let data = change.document.data()
                let category = Category(data: data)
                
                switch change.type {
                case .added:
                    self.onDocumentAdded(change: change, category: category)
                case .modified:
                    self.onDocumentModified(change: change, category: category)
                case .removed:
                    self.onDocumentRemoved(change: change)
                }
            })
            
        })
    }
  
    fileprivate func presentLoginController() {
        let storyboard = UIStoryboard(name: Storyboard.loginStoryboard, bundle: nil)
        let loginVC = storyboard.instantiateViewController(identifier: StoryboardId.loginVC)
        present(loginVC, animated: true, completion: nil)
    }
    
    
    
    @IBAction func favoritesClicked(_ sender: Any) {
        performSegue(withIdentifier: Segues.ToFavorites, sender: self)
        
    }
    
    
    @IBAction func loginOutClicked(_ sender: Any) {
        
        guard let user = Auth.auth().currentUser else { return }
        if user.isAnonymous {
            presentLoginController()
        } else {
            do {
                // we sign the current non-anonymous user out
                try Auth.auth().signOut()
                // removing the listeners etc. We don't want any memory leaks
                UserService.logoutUser()
                // and sign an anonymous user in, so the next time we start the app, the anonymous user will still be signed in
                Auth.auth().signInAnonymously { (result, error) in
                    if let error = error {
                        debugPrint(error)
                        Auth.auth().handleFireAuthError(error: error, vc: self)
                    }
                    self.presentLoginController()
                }
            } catch {
                debugPrint(error)
                Auth.auth().handleFireAuthError(error: error, vc: self)
            }
        }
        
    }
    
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func onDocumentAdded(change: DocumentChange, category: Category) {
        let newIndex = Int(change.newIndex)
        categories.insert(category, at: newIndex)
        // inserts item and reloads data also
        collectionView.insertItems(at: [IndexPath(item: newIndex, section: 0)])
    }
    
    func onDocumentModified(change: DocumentChange, category: Category) {
        if change.newIndex == change.oldIndex {
            // Item changed, but remained in the same position
            let index = Int(change.newIndex)
            categories[index] = category
            // Only reloading the item at the given index, not the whole collection view. This way, we are much more efficient
            collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
        } else {
            // Item changed and changed position
            let oldIndex = Int(change.oldIndex)
            let newIndex = Int(change.newIndex)
            categories.remove(at: oldIndex)
            categories.insert(category, at: newIndex)
            
            collectionView.moveItem(at: IndexPath(item: oldIndex, section: 0), to: IndexPath(item: newIndex, section: 0))
        }
    }
    
    func onDocumentRemoved(change: DocumentChange) {
        let oldIndex = Int(change.oldIndex)
        categories.remove(at: oldIndex)
        collectionView.deleteItems(at: [IndexPath(item: oldIndex, section: 0)])
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.CategoryCell, for: indexPath) as? CategoryCell {
            
            cell.configureCell(category: categories[indexPath.item])
            return cell
        }
        return UICollectionViewCell()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // get the current width of the device the app is currently running on
        let width = view.frame.width
        // get the cell width based on the device width minus 50, because we have 20 spacing trailing and leading and 10 minimum space. We devide by 2 because we want two cells in one row (or section).
        let cellWidth = (width - 30) / 2
        let cellHeight = cellWidth * 1.5
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategory = categories[indexPath.item]
        performSegue(withIdentifier: Segues.ToProducts, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.ToProducts {
            if let destination = segue.destination as? ProductsVC {
                destination.category = selectedCategory
            }
        } else if segue.identifier == Segues.ToFavorites {
            if let destination = segue.destination as? ProductsVC {
                destination.category = selectedCategory
                destination.showFavorites = true
            }
        }
    }
    
}



// MARK: - Reference

//func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//    selectedCategory = categories[indexPath.item]
//    performSegue(withIdentifier: Segues.ToProducts, sender: self)
//}
//
//override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    if segue.identifier == Segues.ToProducts {
//        if let destination = segue.destination as? ProductsVC {
//            destination.category = selectedCategory
//        }
//    }
//}


//    func fetchDocument() {
//        let docRef = db.collection("categories").document("8oOF0Gy0ZHcSqLSdMe7E")
//
//        docRef.addSnapshotListener { (snap, error) in
//            self.categories.removeAll()
//            guard let data = snap?.data() else { return }
//            let newCategory = Category(data: data)
//            self.categories.append(newCategory)
//            self.collectionView.reloadData()
//        }
//    }


//    func fetchCollection() {
//        let collectionRef = db.collection("categories")
//
//
//        listener = collectionRef.addSnapshotListener { (snap, error) in
//            guard let documents = snap?.documents else { return }
//
//            print(snap?.documentChanges.count)
//
//            self.categories.removeAll()
//            for document in documents {
//                let data = document.data()
//                let newCategory = Category(data: data)
//                self.categories.append(newCategory)
//            }
//            self.collectionView.reloadData()
//        }
//    }

