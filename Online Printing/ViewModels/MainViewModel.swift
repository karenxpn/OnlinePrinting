//
//  CategoryViewModel.swift
//  Online Printing
//
//  Created by Karen Mirakyan on 09.10.20.
//

import Foundation
class MainViewModel: ObservableObject {
    @Published var categories = [CategoryModel]()
    @Published var loading: Bool = false
    
    init() {
        getAllCategories()
    }
    
    func getAllCategories() {
        self.loading = true
        CategoryService().fetchCategories { (response) in
            if let response = response {
                self.categories = response
                self.loading = false
            }
        }
    }
}
