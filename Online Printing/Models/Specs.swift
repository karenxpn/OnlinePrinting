//
//  Dimensions.swift
//  Online Printing
//
//  Created by Karen Mirakyan on 07.12.20.
//

import Foundation
struct Specs: Codable, Identifiable {
    let id = UUID()
    var name: String
    var oneSide_ColorPrice: Int
    var bothSide_ColorPrice:Int
    var minCount: Int
    var minCountDiscount: Int
    var maxCount: Int
    var maxCountDiscount: Int
    var additionalFunctionality: [AdditionalFunctionality]
    var minBorderCount: Int
    var typeUnit: String
    var measurementUnit: String
}
