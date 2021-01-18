//
//  MockPaymentService.swift
//  Online PrintingTests
//
//  Created by Karen Mirakyan on 15.01.21.
//

import Foundation
@testable import Online_Printing


class MockPaymentService {
    var returnErrorOnInit: Bool = false
    var returnErrorOnUpdateOrderID: Bool = false
    var returnErrorOnGetPaymentDetails: Bool = false
    var getDetailsPaymentResponseCode: String = "00"
}

extension MockPaymentService: PaymentServiceProtocol {
    func payWithIdram(amount: Int) {
        
    }
    
    func updateOrderID(completion: @escaping (Int?) -> ()) {
        if self.returnErrorOnUpdateOrderID {
            completion( nil )
        } else {
            completion( 234000 )
        }
    }
    
    func initPayment(model: InitPaymentRequest, completion: @escaping (InitPaymentResponse?) -> ()) {
        if self.returnErrorOnInit {
            completion( nil )
        } else {
            completion( InitPaymentResponse(PaymentID: "EEA93DEB-7D9A-492B-895F-CB12B0A47F49", ResponseCode: 1, ResponseMessage: "Response Message"))
        }
    }
    
    func getPaymentDetails(model: PaymentDetailsRequest, completion: @escaping (PaymentDetailsResponse?) -> ()) {
        if self.returnErrorOnGetPaymentDetails {
            completion( nil )
        } else {
            completion( PaymentDetailsResponse(Amount: 10, ApprovedAmount: 10, ApprovalCode: "00", CardNumber: "", ClientName: "", ClientEmail: "", Currency: "", DateTime: "", DepositedAmount: 10, Description: "", MerchantId: "", Opaque: "", OrderID: "", PaymentState: "", PaymentType: 1, ResponseCode: self.getDetailsPaymentResponseCode, rrn: "", TerminalId: "", TrxnDescription: "", OrderStatus: "", RefundedAmount: 0, CardHolderID: "", MDOrderID: "", PrimaryRC: "", ExpDate: "", ProcessingIP: "", BindingID: "", ActionCode: "", ExchangeRate: 109))
        }
    }
    
    func calculateTotalAmount(products: [CartItemModel], completion: @escaping (Int) -> ()) {
        completion ( 10 )
    }
    
}
