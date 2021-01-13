//
//  CategoryViewModelTest.swift
//  Online PrintingTests
//
//  Created by Karen Mirakyan on 13.01.21.
//

import XCTest
@testable import Online_Printing


class CategoryViewModelTest: XCTestCase {
    
    var viewModel: CategoryViewModel!
    
    override func setUp() {
        viewModel = .init( dataManager: MockCategoryService.shared )
    }

    
    func testCategoryListIsNotNil() {
        XCTAssertNotNil(viewModel.categories)
    }
    
    func testCategoryListValidation() {
        XCTAssertFalse(viewModel.categories.isEmpty)
    }
}
