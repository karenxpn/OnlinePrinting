//
//  MainViewModelTest.swift
//  Online PrintingTests
//
//  Created by Karen Mirakyan on 13.01.21.
//

import XCTest
@testable import Online_Printing


class MainViewModelTest: XCTestCase {
    
    var viewModel: MainViewModel!

    override func setUp() {
        viewModel = .init()
    }
    
    func testPlaceOrderButtonClickable() {
        viewModel.selectedCategory = CategoryModel(name: "", image: "", specs: [Specs(name: "A4", oneSide_ColorPrice: 120, bothSide_ColorPrice: 220, minCount: 100, minCountDiscount: 10, maxCount: 1000, maxCountDiscount: 20, additionalFunctionality: [], minBorderCount: 20, typeUnit: "Side", measurementUnit: "hat")])
        
        viewModel.selectedCategorySpec = Specs(name: "A4", oneSide_ColorPrice: 120, bothSide_ColorPrice: 220, minCount: 100, minCountDiscount: 10, maxCount: 1000, maxCountDiscount: 20, additionalFunctionality: [], minBorderCount: 20, typeUnit: "Side", measurementUnit: "hat")

        viewModel.size = "A4"
        viewModel.fileName = "klfdjg"
        viewModel.typeOfPrinting = "One Side"
        viewModel.count = "100"


        XCTAssertTrue(viewModel.buttonClickable)
        // test fails cause of receive( on: RunLoop.main ) in view model
        
    }
}
