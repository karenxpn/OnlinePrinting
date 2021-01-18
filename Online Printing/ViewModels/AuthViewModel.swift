//
//  AuthViewModel.swift
//  Online Printing
//
//  Created by Karen Mirakyan on 10.12.20.
//

import Foundation

class AuthViewModel: ObservableObject {
    @Published var number: String = ""
    @Published var confirmationCode: String = ""
    @Published var showLoading: Bool = false
    @Published var activeAlert: AuthActiveAlert? = nil
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var verificationID: String = ""
    @Published var changeSendVerificationIconColor: Bool = false
    @Published var showSeet: Bool = false
    
    var authDataManager: AuthServiceProtocol
    
    init( dataManager: AuthServiceProtocol = AuthService.shared ) {
        self.authDataManager = dataManager
    }
    
    func signUp() {
        authDataManager.signUp(phoneNumber: self.number) { verificationID in
            if let verificationID = verificationID {
                self.verificationID = verificationID
            } else {
                self.placeError(for: .verificationIDError)
            }
        }
    }
    
    func logTheUser() {
        self.showLoading = true
        authDataManager.signIn(verificationID: self.verificationID, verificationCode: self.confirmationCode) { (result) in
            if result == true {
                self.showLoading = false
                self.showSeet = false
            } else {
                self.showLoading = false
                
                self.placeError(for: .signInError)
            }
        }
    }
    
    func logOutUser() {
        self.showLoading = true
        authDataManager.signOut { (response) in
            if response == true {
                self.showLoading = false
            } else {
                self.showLoading = false
                self.placeError(for: .signOutError)
            }
        }
    }
    
    func placeError( with alertMessage: String = AlertMessages.defaultErrorMessage, for activeAlert: AuthActiveAlert) {
        self.activeAlert = activeAlert
        self.alertMessage = alertMessage
        self.showAlert = true
    }
}
