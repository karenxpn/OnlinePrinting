//
//  RedirectResponse.swift
//  FlyShop
//
//  Created by Karen Mirakyan on 6/18/20.
//  Copyright © 2020 Karen Mirakyan. All rights reserved.
//

import Foundation
struct RedirectResponse: Codable {
    var orderID: String
    var responseCode: String
    var paymentID: String
    var opaque: String
}
