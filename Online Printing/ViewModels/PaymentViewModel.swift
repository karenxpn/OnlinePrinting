//
//  PaymentViewModel.swift
//  Online Printing
//
//  Created by Karen Mirakyan on 27.12.20.
//

import Foundation

class PaymentViewModel: ObservableObject {
    
    @Published var amount: Int = 0
    
    func payWithIdram() {
        PaymentService().payWithIdram(amount: self.amount)
    }
    
    func calculateTotalAmount(products: [CartItemModel]) {
        for product in products {
            amount += product.totalPrice
        }
    }
}
