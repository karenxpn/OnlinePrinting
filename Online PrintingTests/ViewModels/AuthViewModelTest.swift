//
//  AuthViewModelTest.swift
//  Online PrintingTests
//
//  Created by Karen Mirakyan on 16.01.21.
//

import XCTest
@testable import Online_Printing

class AuthViewModelTest: XCTestCase {
    
    var authService: StubAuthService!
    var viewModel: AuthViewModel!
    
    override func setUp() {
        self.authService = StubAuthService()
        self.viewModel = AuthViewModel(dataManager: self.authService)
    }
    
    // Test SignUp user
    func testSignUpWithError() {
        self.authService.returnSignUpError = true
        
        viewModel.signUp()
        
        XCTAssertEqual(viewModel.activeAlert, .verificationIDError)
        XCTAssertEqual(viewModel.alertMessage, AlertMessages.defaultErrorMessage)
    }
    
    func testSignUpWithSuccess() {
        self.authService.returnSignUpError = false
        
        viewModel.signUp()
        
        XCTAssertNotEqual(viewModel.verificationID, "")
    }
    
    
    // Test LogIn user
    func testLogInUserrWithFailure() {
        self.authService.returnSignUpError = false
        self.authService.returnSingInError = true
        
        viewModel.logTheUser()
        
        XCTAssertEqual(viewModel.activeAlert, .signInError)
    }
    
    func testLogInUserWithSuccess() {
        self.authService.returnSignOutError = false
        self.authService.returnSingInError = false
        
        viewModel.logTheUser()
        
        XCTAssertFalse(viewModel.showSeet)
    }
    
    // Test LogOut user
    
    func testUserLogOutWithError() {
        self.authService.returnSignOutError = true
        viewModel.logOutUser()
        
        XCTAssertEqual(viewModel.activeAlert, .signOutError)
    }
    
    func testUserLogOutWithSuccess() {
        self.authService.returnSignOutError = false
        viewModel.logOutUser()
        
        XCTAssertNil(viewModel.activeAlert)
        XCTAssertFalse(viewModel.showLoading)
    }
}
