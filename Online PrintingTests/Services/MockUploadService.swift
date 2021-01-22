//
//  MockUploadService.swift
//  Online PrintingTests
//
//  Created by Karen Mirakyan on 15.01.21.
//

import Foundation
@testable import Online_Printing

class MockUploadService {
    
    var returnErrorUpload = false
    var returnErrorPlacement = false
}

extension MockUploadService: UploadServiceProtocol {
    func placeOrder(orderList: [CartItemModel], address: String, fileURLS: [String], paymentMethod: String, completion: @escaping (Bool) -> ()) {
        if returnErrorPlacement == true {
            completion( false )
        } else {
            completion( true )
        }
    }
    
    func storeLastVisitedCategory(category: CategoryModel, completion: @escaping (Data?) -> ()) {
        
    }
    
    
    func uploadFileToStorage(cartItems: [CartItemModel], completion: @escaping ([String]?) -> ()) {
        if returnErrorUpload == true {
            completion ( nil )
        } else {
            completion( ["karen", "martin"])
        }
    }
    
    func calculateAmount(selectedCategorySpecs: Specs, count: Int, typeOfPrinting: String, additionalFunctionalityTitle: String, completion: @escaping (Int) -> ()) {
        
    }
}
