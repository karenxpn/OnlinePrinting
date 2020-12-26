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
        IdramPaymentManager.pay(withReceiverName: "Online Printing", receiverId: "044151415", title: UUID().uuidString, amount: amount as NSNumber, hasTip: false, callbackURLScheme: "onlineprinting://")
    }
    
    func calculateTotalAmount( products: [CartItemModel], completion: @escaping( Int ) -> () ) {
        var amount: Int = 0
        
        for product in products {
            amount += product.totalPrice
        }
        
        DispatchQueue.main.async {
            completion( amount )
        }
    }
}
