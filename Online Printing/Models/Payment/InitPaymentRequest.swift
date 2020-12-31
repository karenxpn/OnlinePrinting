//
//  InitPaymentRequest.swift
//  FlyShop
//
//  Created by Karen Mirakyan on 6/4/20.
//  Copyright © 2020 Karen Mirakyan. All rights reserved.
//

import Foundation
struct InitPaymentRequest: Codable {
    var ClientID: String
    var Username: String
    var Password: String
    var Currency: String?
    var Description: String
    var OrderID: Int
    var Amount: Decimal
    var BackURL: String?
    var Opaque: String?
    var CardHolderID: Int?    
}
