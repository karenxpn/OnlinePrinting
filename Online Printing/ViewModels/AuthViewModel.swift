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
    @Published var showAlert: Bool = false
    @Published var verificationID: String = ""
    @Published var changeSendVerificationIconColor: Bool = false
    @Published var showSeet: Bool = false
    
    func signUp() {
        AuthService().signUp(phoneNumber: self.number) { verificationID in
            self.verificationID = verificationID ?? ""
        }
    }
    
    func logTheUser() {
        self.showLoading = true
        AuthService().signIn(verificationID: self.verificationID, verificationCode: self.confirmationCode) { (result) in
            if result == true {
                self.showLoading = false
                self.showSeet = false
            } else {
                self.showLoading = false
                self.showAlert = true
            }
        }
    }
    
    func logOutUser() {
        self.showLoading = true
        AuthService().signOut { (response) in
            if response == true {
                self.showLoading = false
            } else {
                self.showLoading = false
                self.showAlert = true
            }
        }
    }
}
