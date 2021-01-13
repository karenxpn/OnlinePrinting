//
//  MockPaymentService.swift
//  Online PrintingTests
//
//  Created by Karen Mirakyan on 13.01.21.
//

import Foundation
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
    
    let mockInitPaymentResponse = InitPaymentResponse(PaymentID: "PaymentID", ResponseCode: 1, ResponseMessage: "Response Message")
    let mockGetPaymentResponse = PaymentDetailsResponse(Amount: 120, ApprovedAmount: 120, ApprovalCode: "90", CardNumber: "000000", ClientName: "Karen Mirakyan", ClientEmail: "", Currency: "", DateTime: "", DepositedAmount: 120, Description: "", MerchantId: "", Opaque: "", OrderID: "123000", PaymentState: "", PaymentType: 1, ResponseCode: "", rrn: "", TerminalId: "", TrxnDescription: "", OrderStatus: "", RefundedAmount: 0, CardHolderID: "", MDOrderID: "", PrimaryRC: "", ExpDate: "", ProcessingIP: "", BindingID: "", ActionCode: "", ExchangeRate: 123)
}

extension MockPaymentService: PaymentServiceProtocol {
    func payWithIdram(amount: Int) {
        
    }
    
    func updateOrderID(completion: @escaping (Int?) -> ()) {
        
    }
    
    func initPayment(model: InitPaymentRequest, completion: @escaping (InitPaymentResponse?) -> ()) {
        initPaymentWasCalled = true
        
        if shouldReturnError {
            completion( nil )
        } else {
            completion( mockInitPaymentResponse )
        }
    }
    
    func getPaymentDetails(model: PaymentDetailsRequest, completion: @escaping (PaymentDetailsResponse?) -> ()) {
        getPaymentDetailsCalled = true
        
        if shouldReturnError {
            completion( nil )
        } else {
            completion( mockGetPaymentResponse )
        }
    }
    
    func calculateTotalAmount(products: [CartItemModel], completion: @escaping (Int) -> ()) {
        
    }
}
