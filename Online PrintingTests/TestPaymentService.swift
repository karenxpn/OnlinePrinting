//
//  TestPaymentService.swift
//  Online PrintingTests
//
//  Created by Karen Mirakyan on 13.01.21.
//

import XCTest
@testable import Online_Printing

class TestPaymentService: XCTestCase {

    let paymentService = MockPaymentService()
    
    override func setUp() {
    }
    
    func testInitPayment() {
        
        paymentService.shouldReturnError = false
        
        paymentService.initPayment(model: InitPaymentRequest(ClientID: "ClientID", Username: "Username", Password: "Password", Currency: nil, Description: "Desctiption", OrderID: 2342605, Amount: 120, BackURL: nil, Opaque: nil, CardHolderID: nil)) { (response) in
            guard let response = response else {
                XCTFail()
                return
            }
            
            do {
                print(response)
                XCTAssertNotNil(response)
            } catch {
                XCTFail(error.localizedDescription)
            }
        }
    }
    
    func testGetPaymentResponse() {
        paymentService.shouldReturnError = false
        
        paymentService.getPaymentDetails(model: PaymentDetailsRequest(PaymentID: "PaymentID", Username: "Username", Password: "Password")) { (response) in
            guard let response = response else {
                XCTFail()
                return
            }
            
            do {
                print(response)
                XCTAssertNotNil(response)
            }
        }
    }

}
