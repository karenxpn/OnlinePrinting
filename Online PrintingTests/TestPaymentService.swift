//
//  TestPaymentService.swift
//  Online PrintingTests
//
//  Created by Karen Mirakyan on 13.01.21.
//

import XCTest
import Alamofire
@testable import Online_Printing

class TestPaymentService: XCTestCase {

    let paymentService = MockPaymentService()
    
    override func setUp() {
    }
    
    func testInitPaymentModel() {
        
        paymentService.initPayment(model: paymentService.mockInitPaymentRequest) { (response ) in
            XCTAssertNotNil(response)
            XCTAssertEqual(response?.PaymentID, "EEA93DEB-7D9A-492B-895F-CB12B0A47F49")
        }
    }
    
    func testGetPaymentDetailsModel() {
        paymentService.getPaymentDetails(model: paymentService.mockGetPaymentResponseRequest) { (response) in
            XCTAssertNotNil(response)
            XCTAssertEqual(response?.Amount, 10)
        }

    }
    

}
