//
//  AuthService.swift
//  Online Printing
//
//  Created by Karen Mirakyan on 10.12.20.
//

import Foundation
import FirebaseAuth

class AuthService {
    func signUp( phoneNumber: String, completion: @escaping ( String? ) -> () ) {
                
        PhoneAuthProvider.provider().verifyPhoneNumber("+374\(phoneNumber)", uiDelegate: nil) { (verificationID, error) in
            if error != nil {
                DispatchQueue.main.async {
                    completion( nil )
                }
                return
            }
            
            DispatchQueue.main.async {
                completion( verificationID )
            }
        }
    }
    
    func signIn( verificationID: String, verificationCode: String, completion: @escaping ( Bool ) -> () ) {
        if verificationID == "" {
            DispatchQueue.main.async {
                completion( false )
            }
            return
        }
        
        let credential =  PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verificationCode)

        
        Auth.auth().signIn(with: credential) { (result, error) in
            if error != nil {
                DispatchQueue.main.async {
                    completion( false )
                    print(error?.localizedDescription ?? "Error occured")
                }
                return
            }
            
            DispatchQueue.main.async {
                completion( true )
            }
        }
    }
    
    func signOut(completion: @escaping ( Bool ) -> () ) {
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                completion( true )
            }
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
            DispatchQueue.main.async {
                completion( false )
            }
        }
    }
}
