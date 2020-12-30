//
//  AdditionalFunctionality.swift
//  Online Printing
//
//  Created by Karen Mirakyan on 30.12.20.
//

import Foundation
struct AdditionalFunctionality: Codable, Identifiable, Hashable {
    let id = UUID()
    var functionalityTitle: String
    var functionalityAdditionalPrice: Int
}
