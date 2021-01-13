//
//  MockCategoryService.swift
//  Online PrintingTests
//
//  Created by Karen Mirakyan on 13.01.21.
//

import Foundation
import Combine
import CombineFirebase
import Firebase
import FirebaseFirestore
@testable import Online_Printing

class MockCategoryService {
    static let shared: CategoryServiceProtocol = MockCategoryService()
    
    private init() { }
}

extension MockCategoryService: CategoryServiceProtocol {
    
    func fetchCategories() -> AnyPublisher<[CategoryModel], Error> {

        let arr = [Just(CategoryModel(name: "Test Category", image: "", specs: [])),
                   Just(CategoryModel(name: "Test Category1", image: "", specs: [])),
                   Just(CategoryModel(name: "Test Category2", image: "", specs: [])),
                   Just(CategoryModel(name: "Test Category3", image: "", specs: []))]
        
        return Publishers.MergeMany( arr)
            .collect()
            .mapError{ $0 as Error}
//            .receive(on: DispatchQueue.main)  this line is removed as view model changes publishers asynchroniously but test is synchroniuos
            .eraseToAnyPublisher()
    }    
}
