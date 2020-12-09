//
//  CategoryService.swift
//  Online Printing
//
//  Created by Karen Mirakyan on 27.09.20.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class CategoryService {
    let db = Firestore.firestore()
    
    func fetchCategories(completion: @escaping([CategoryModel]?) -> ()) {
        db.collection("Categories").addSnapshotListener { (snapshot, error) in
            if error != nil {
                DispatchQueue.main.async {
                    completion( nil )
                }
                return
            }
            
            if snapshot?.isEmpty != true {
                var categories = [CategoryModel]()
                for document in snapshot!.documents {
                    if let model = try? document.data(as: CategoryModel.self) {
                        categories.append(model)
                    }
                }
                
                DispatchQueue.main.async {
                    completion( categories )
                }
            }
        }
    }
}
