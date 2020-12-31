//
//  ConfirmPaymentRequest.swift
//  FlyShop
//
//  Created by Karen Mirakyan on 6/4/20.
//  Copyright © 2020 Karen Mirakyan. All rights reserved.
//

import Foundation
struct ConfirmPaymentRequest: Codable {
    var PaymentID: String
    var Username: String
    var Password: String
    var Amount: Decimal
}
