//
//  CategoryService.swift
//  Online Printing
//
//  Created by Karen Mirakyan on 27.09.20.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import CombineFirebaseFirestore
import Combine

protocol CategoryServiceProtocol {
    func fetchCategories() -> AnyPublisher<[CategoryModel], Error>
}

class CategoryService {
    static let shared: CategoryServiceProtocol = CategoryService()
    
    private init() { }
}

extension CategoryService: CategoryServiceProtocol {
    func fetchCategories() -> AnyPublisher<[CategoryModel], Error> {
        let db = Firestore.firestore()

        return db.collection("Categories")
            .publisher(as: CategoryModel.self)
            .mapError { $0 as Error }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        
    }
}
