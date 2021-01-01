//
//  PaymentService.swift
//  Online Printing
//
//  Created by Karen Mirakyan on 27.12.20.
//

import Foundation
import IdramMerchantPayment
import Firebase
import Alamofire

class PaymentService {
    func payWithIdram(amount: Int) {
        print(amount)
        IdramPaymentManager.pay(withReceiverName: "Online Printing", receiverId: Credentials().idramID, title: UUID().uuidString, amount: amount as NSNumber, hasTip: false, callbackURLScheme: "onlineprinting")
    }
    
    func getPaymentDetails(model: PaymentDetailsRequest, completion: @escaping( PaymentDetailsResponse?) -> () ){
        guard let url = URL(string: "\(URLS().BASE_URL)GetPaymentDetails" ) else {
            DispatchQueue.main.async {
                completion( nil )
            }
            return
        }
        
        AF.request(url,
                   method: .post,
                   parameters: model,
                   encoder: JSONParameterEncoder.default).responseDecodable(of: PaymentDetailsResponse.self) { (response) in
                    DispatchQueue.main.async {
                        completion( response.value )
                    }
        }
    }
    
    func updateOrderID( completion: @escaping( Int? ) -> () ) {
        let db = Firestore.firestore()
        let sfReference = db.collection("OrderID").document("ORDERID")
        
        db.runTransaction{ (transaction, errorPointer) -> Any? in
            let sfDocument: DocumentSnapshot
            do {
                try sfDocument = transaction.getDocument(sfReference)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
            
            guard let orlOrderID = sfDocument.get("OrderID") as? Int else {
                let error = NSError(
                    domain: "AppErrorDomain",
                    code: -1,
                    userInfo: [
                        NSLocalizedDescriptionKey: "Unable to retrieve population from snapshot \(sfDocument)"
                    ]
                )
                errorPointer?.pointee = error
                return nil
            }
            
            transaction.updateData(["OrderID": orlOrderID + 1], forDocument: sfReference)
            return orlOrderID + 1
        } completion: { (object, error) in
            if error != nil {
                DispatchQueue.main.async {
                    completion( nil )
                }
            } else {
                if let orderID = object as? Int {
                    DispatchQueue.main.async {
                        completion( orderID )
                    }
                }
            }
        }
    }
    

    func initPayment( model: InitPaymentRequest ,completion: @escaping ( InitPaymentResponse? ) -> () ) {
        guard let postURL = URL(string: "\(URLS().BASE_URL)InitPayment" ) else {
            DispatchQueue.main.async {
                completion( nil )
            }
            return
        }
        
        AF.request(postURL,
                   method: .post,
                   parameters: model,
                   encoder: JSONParameterEncoder.default).responseDecodable(of: InitPaymentResponse.self) { (response) in
                    DispatchQueue.main.async {
                        completion( response.value)
                    }
        }
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
