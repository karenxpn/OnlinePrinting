//
//  UploadViewModel.swift
//  Online Printing
//
//  Created by Karen Mirakyan on 20.11.20.
//

import Foundation

class UploadViewModel : ObservableObject {
    @Published var info: String = ""
    @Published var count: String = ""
    @Published var size: String = ""
    @Published var sizePrice: String = ""
    @Published var fileName: String = ""
    @Published var path: URL? = nil
    @Published var loading: Bool = false
    @Published var activeAlert: ActiveAlert? = nil
    @Published var alertMessage: String = ""
    @Published var orderList = [CartItemModel]()

    
    func placeOrder() {
        self.loading = true
        UploadService().uploadFileToStorage(cartItems: self.orderList, completion: { (response) in
            if let response = response {
                UploadService().placeOrder(orderList: self.orderList, fileURLS: response) { (orderPlacementResponse) in
                    if orderPlacementResponse == true {
                        self.orderList.removeAll(keepingCapacity: false)
                        self.loading = false
                    } else {
                        print("Fuck")
                    }
                }
                
            }
        })
    }
}
