//
//  PaymentViewModel.swift
//  Online Printing
//
//  Created by Karen Mirakyan on 27.12.20.
//

import Foundation

class PaymentViewModel: ObservableObject {
    
    @Published var products = [CartItemModel]()
    
    func payWithIdram() {
        PaymentService().calculateTotalAmount(products: products, completion: { amount in
            PaymentService().payWithIdram(amount: amount)
        })
    }
}
