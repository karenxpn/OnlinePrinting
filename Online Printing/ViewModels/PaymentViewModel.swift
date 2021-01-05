//
//  PaymentViewModel.swift
//  Online Printing
//
//  Created by Karen Mirakyan on 27.12.20.
//

import Foundation

class PaymentViewModel: ObservableObject {
    
    @Published var clientID: String = Credentials().clientID
    @Published var username: String = Credentials().username
    @Published var password: String = Credentials().password
    
    @Published var paymentID: String = ""
    @Published var description: String = ""
    @Published var orderID: Int = 0
    @Published var amount: Decimal = 0
    @Published var paymentDetails: PaymentDetailsResponse? = nil
    
    @Published var loading: Bool = false
    @Published var products = [CartItemModel]()
    @Published var paymentMethod: String = ""
    @Published var navigateToCheckoutView: Bool = false
    @Published var openPayment: Bool = false
    
    // Alert
    @Published var activeAlert: ActiveAlert? = nil
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var alertTitle: String = ""
    
    func payWithIdram() {
        PaymentService().calculateTotalAmount(products: products, completion: { amount in
            PaymentService().payWithIdram(amount: amount)
        })
    }
    
    func initPayment() {
        PaymentService().updateOrderID { (updateResponse) in
            if let orderID = updateResponse {
                self.orderID = orderID
                
                PaymentService().calculateTotalAmount(products: self.products) { (amount) in
                    self.amount = Decimal(10)
                    let model = InitPaymentRequest(ClientID: self.clientID, Username: self.username, Password: self.password, Currency: nil, Description: self.description, OrderID: self.orderID, Amount: self.amount, BackURL: "onlineprinting", Opaque: nil, CardHolderID: nil)
                    
                    PaymentService().initPayment(model: model) { (initPaymentResponse) in
                        if let response = initPaymentResponse {
                            if response.ResponseCode == 1 {
                                self.paymentID = response.PaymentID
                                self.openPayment.toggle()

                            } else {
                                self.activeAlert = .error
                                self.alertTitle = "Error"
                                self.alertMessage = response.ResponseMessage
                                self.showAlert.toggle()
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func getResponse() {
        
        let model = PaymentDetailsRequest(PaymentID: self.paymentID, Username: self.username, Password: self.password)
        PaymentService().getPaymentDetails(model: model) { (response) in
            if let response = response {
                self.paymentDetails = response
                
                if response.ResponseCode == "00" {
                
                    // upload files
                    

                } else {
                    self.activeAlert = .paymentError
                    self.alertTitle = "Error"
                    self.alertMessage = "Something went wrong"
                    self.showAlert.toggle()
                }
            }
        }
    }
}
