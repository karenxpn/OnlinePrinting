//
//  CategoryModel.swift
//  Online Printing
//
//  Created by Karen Mirakyan on 27.09.20.
//

import Foundation
struct CategoryModel: Codable, Identifiable {
    let id = UUID()
    var name: String
    var image: String
    var specs: [Specs]
}
