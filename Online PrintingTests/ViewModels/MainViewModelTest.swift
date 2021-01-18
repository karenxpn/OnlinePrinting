//
//  MainViewModelTest.swift
//  Online PrintingTests
//
//  Created by Karen Mirakyan on 13.01.21.
//

import XCTest
@testable import Online_Printing


class MainViewModelTest: XCTestCase {
    
    var uploadService: MockUploadService!
    var paymentServce: MockPaymentService!
    var viewModel: MainViewModel!

    
    override func setUp() {
        self.uploadService = MockUploadService()
        self.paymentServce = MockPaymentService()
        viewModel = .init(dataManager: self.uploadService, paymentDataManager: self.paymentServce)
    }
    
    // Upload files test
    
    func testUploadFilesWithFailResponse() {
        self.uploadService.returnErrorUpload = true
//        self.uploadService.returnErrorPlacement = false

        // placementError is false by default
                
        self.viewModel.placeOrder()
        
        XCTAssertTrue(self.viewModel.activeAlert == .error)
        XCTAssertFalse(self.viewModel.loading)
        XCTAssertEqual(self.viewModel.alertMessage, AlertMessages.defaultErrorMessage)
        XCTAssertTrue(self.viewModel.showAlert)
                
    }
    
    func testUploadFilesWithSuccessResponse() {
        self.uploadService.returnErrorUpload = false
//        self.uploadService.returnErrorPlacement = false
        // placementError is false by default

        self.viewModel.placeOrder()
        
        XCTAssertTrue(self.viewModel.orderList.isEmpty)
    }
    
    func testPlaceOrderWithFailResponse() {
        self.uploadService.returnErrorPlacement = true
        
        self.viewModel.placeOrder()
        
        XCTAssertTrue(self.viewModel.activeAlert == .error)
        XCTAssertFalse(self.viewModel.loading)
    }
    
    func testPlaceOrderWithSuccessResponse() {
        self.uploadService.returnErrorPlacement = false
        
        self.viewModel.placeOrder()
        
        XCTAssertFalse(self.viewModel.loading)
        XCTAssertEqual(self.viewModel.activeAlert, .placementCompleted)
        XCTAssertTrue(self.viewModel.orderList.isEmpty)
        XCTAssertEqual(self.viewModel.alertMessage, AlertMessages.uploadSuccessMessage)
    }
    
    // payment test
    
    func testInitPaymentWithErrorOnUpdateID() {
        self.paymentServce.returnErrorOnUpdateOrderID = true
        
        self.viewModel.initPayment()
        
        XCTAssertEqual(self.viewModel.activeAlert, .error)
        XCTAssertEqual(self.viewModel.alertMessage, AlertMessages.defaultErrorMessage)
    }
    
    func testInitPaymentWithSuccessOnUpdateID() {
        
        self.viewModel.initPayment()
        
        XCTAssertEqual(self.viewModel.loading, false)
        XCTAssertEqual(self.viewModel.paymentID, "EEA93DEB-7D9A-492B-895F-CB12B0A47F49")
    }
    
    func testInitPaymentWithSuccessOnUpdateIDButWithErrorOnInit() {
        self.paymentServce.returnErrorOnInit = true
        
        self.viewModel.initPayment()
        
        
        XCTAssertEqual(self.viewModel.activeAlert, .error)
        XCTAssertEqual(self.viewModel.alertMessage, AlertMessages.defaultErrorMessage)
        
    }
    
    func testInitPaymentWithSuccessOnUpdateIDAndWithSuccessInit() {
        self.viewModel.initPayment()
        
        XCTAssertEqual(self.viewModel.loading, false)
        XCTAssertEqual(self.viewModel.paymentID, "EEA93DEB-7D9A-492B-895F-CB12B0A47F49")
        
    }
    
    func testGetPaymentDetailsWithError() {
        self.paymentServce.returnErrorOnGetPaymentDetails = true
        self.viewModel.getResponse()
                
        XCTAssertEqual(self.viewModel.activeAlert, .error)
        XCTAssertEqual(self.viewModel.alertMessage, AlertMessages.defaultErrorMessage)
    }
    
    
    func testGetPaymentDetailsWithFailureResponseCode() {
        self.paymentServce.getDetailsPaymentResponseCode = "11"
        self.viewModel.getResponse()
        
        XCTAssertEqual(self.viewModel.activeAlert, .error)
    }
    
    func testGetPaymentDetailsWithSuccess() {
        
        self.viewModel.getResponse()
        
        XCTAssertFalse(self.viewModel.loading)
        XCTAssertEqual(self.viewModel.activeAlert, .placementCompleted)
        XCTAssertTrue(self.viewModel.orderList.isEmpty)
        XCTAssertEqual(self.viewModel.alertMessage, AlertMessages.uploadSuccessMessage)
        
    }
}
