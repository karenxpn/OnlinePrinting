//
//  CategoryViewModel.swift
//  Online Printing
//
//  Created by Karen Mirakyan on 09.10.20.
//

import Foundation
import Combine

class CategoryViewModel: ObservableObject {
    @Published var categories = [CategoryModel]()
    @Published var loading: Bool = false
    
    var cancelBag = Set<AnyCancellable>()
    var dataManager: CategoryServiceProtocol
    
    init(dataManager: CategoryServiceProtocol = CategoryService.shared) {
        self.dataManager = dataManager
        getAllCategories()
    }
}

extension CategoryViewModel {
    func getAllCategories() {
        self.loading = true
        dataManager.fetchCategories()
            .sink { (completion) in
                switch completion {
                    case .finished:
                        self.loading = false
                    case .failure(let error): print("❗️ failure: \(error)")
                }
            } receiveValue: { (response) in
                self.categories = response
            }.store(in: &cancelBag)
    }
}
