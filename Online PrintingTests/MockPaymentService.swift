//
//  MockPaymentService.swift
//  Online PrintingTests
//
//  Created by Karen Mirakyan on 13.01.21.
//

import Foundation
import Alamofire
@testable import Online_Printing

class MockPaymentService {
    var shouldReturnError = false
    var initPaymentWasCalled = false
    var getPaymentDetailsCalled = false
    
    func reset() {
        shouldReturnError = false
        initPaymentWasCalled = false
        getPaymentDetailsCalled = false
    }
    
    convenience init() {
        self.init( false )
    }
    
    init(_ shouldReturnError: Bool) {
        self.shouldReturnError = shouldReturnError
    }
    
   let mockInitPaymentRequest = InitPaymentRequest(ClientID: "", Username: "", Password: "", Currency: nil, Description: "", OrderID: 123, Amount: 12, BackURL: nil, Opaque: nil, CardHolderID: nil)
    
    let mockGetPaymentResponseRequest = PaymentDetailsRequest(PaymentID: "", Username: "", Password: "")
}

extension MockPaymentService: PaymentServiceProtocol {
    func payWithIdram(amount: Int) {
        
    }
    
    func updateOrderID(completion: @escaping (Int?) -> ()) {
        
    }
    
    func initPayment(model: InitPaymentRequest, completion: @escaping (InitPaymentResponse?) -> ()) {
        guard let pathString = Bundle(for: type(of: self)).path(forResource: "InitPaymentJson", ofType: "json") else {
            completion( nil )
            fatalError("json not found")
        }
        
        guard let json = try? String(contentsOfFile: pathString, encoding: .utf8) else {
            completion( nil )
            fatalError("Unable to convert json to string")
        }
        
        let jsonData = json.data(using: .utf8)!
        let initPaymentData = try! JSONDecoder().decode(InitPaymentResponse.self, from: jsonData)
        
        completion( initPaymentData )
    }
    
    func getPaymentDetails(model: PaymentDetailsRequest, completion: @escaping (PaymentDetailsResponse?) -> ()) {

        guard let pathString = Bundle(for: type(of: self)).path(forResource: "GetPaymentDetailsJson", ofType: "json") else {
            completion( nil )
            fatalError("json not found")
        }
        
        guard let json = try? String(contentsOfFile: pathString, encoding: .utf8) else {
            completion( nil )
            fatalError("Unable to convert json to string")
        }
        
        let jsonData = json.data(using: .utf8)!
        let initPaymentData = try? JSONDecoder().decode(PaymentDetailsResponse.self, from: jsonData)
        
        completion( initPaymentData )
    }
    
    func calculateTotalAmount(products: [CartItemModel], completion: @escaping (Int) -> ()) {
        
    }
}
