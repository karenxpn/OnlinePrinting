//
//  Dimensions.swift
//  Online Printing
//
//  Created by Karen Mirakyan on 07.12.20.
//

import Foundation
struct Dimensions: Codable, Identifiable {
    let id = UUID()
    var size: String
    var price: String
}
