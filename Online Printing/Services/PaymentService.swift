//
//  PaymentService.swift
//  Online Printing
//
//  Created by Karen Mirakyan on 27.12.20.
//

import Foundation
import IdramMerchantPayment

class PaymentService {
    func payWithIdram(amount: Int) {
        IdramPaymentManager.pay(withReceiverName: "Karen Mirakyan", receiverId: "1", title: "Order Payment", amount: amount as NSNumber, hasTip: false, callbackURLScheme: "onlineprinting://")
    }
}
