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
    var viewModel: MainViewModel!

    
    override func setUp() {
        self.uploadService = MockUploadService()
        viewModel = .init(dataManager: self.uploadService)
    }
    
    func testUploadFilesWithFailResponse() {
        self.uploadService.returnErrorUpload = true
        
        let expectation = self.expectation(description: "Started")
        
        self.viewModel.placeOrder()
        expectation.fulfill()
        
        XCTAssertTrue(self.viewModel.activeAlert == .error)
        XCTAssertFalse(self.viewModel.loading)
        XCTAssertEqual(self.viewModel.alertMessage, "Ցավոք տեղի է ունեցել սխալ")
        XCTAssertTrue(self.viewModel.showAlert)
        
        wait(for: [expectation], timeout: 10)
        
    }
    
    func testUploadFilesWithSuccessResponse() {
        self.uploadService.returnErrorUpload = false
        
        let expectation = self.expectation(description: "Started")
        
        self.viewModel.placeOrder()
        expectation.fulfill()
        
        XCTAssertTrue(self.viewModel.orderList.isEmpty)
        
        wait(for: [expectation], timeout: 10)
        
    }
    
}
