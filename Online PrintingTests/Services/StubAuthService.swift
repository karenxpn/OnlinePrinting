//
//  StubAuthService.swift
//  Online PrintingTests
//
//  Created by Karen Mirakyan on 16.01.21.
//

import Foundation
@testable import Online_Printing

class StubAuthService {
    var returnSignUpError: Bool = false
    var returnSingInError: Bool = false
    var returnSignOutError: Bool = false
}

extension StubAuthService: AuthServiceProtocol {
    func signUp(phoneNumber: String, completion: @escaping (String?) -> ()) {
        if returnSignUpError {
            completion( nil )
        } else {
            completion( "Success" )
        }
    }
    
    func signIn(verificationID: String, verificationCode: String, completion: @escaping (Bool) -> ()) {
        if returnSingInError {
            completion( false )
        } else {
            completion( true )
        }
    }
    
    func signOut(completion: @escaping (Bool) -> ()) {
        if returnSignOutError {
            completion( false )
        } else {
            completion( true )
        }
    }
    
    
}
