//
//  CartItemModel.swift
//  Online Printing
//
//  Created by Karen Mirakyan on 08.12.20.
//

import Foundation
struct CartItemModel: Codable, Identifiable {
    let id = UUID()
    var dimensions: String
    var count: Int
    var totalPrice: Int
    var category: String
    var image: String
    var filePath: URL
}
