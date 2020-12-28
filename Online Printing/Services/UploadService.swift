//
//  UploadService.swift
//  Online Printing
//
//  Created by Karen Mirakyan on 20.11.20.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage
import FirebaseAuth
import Combine
import CombineFirebaseFirestore

protocol UploadServiceProtocol {
    func uploadFileToStorage( cartItems: [CartItemModel], completion: @escaping ( [String]? ) -> () )
    func countPrice( count: Int, price: Int ) -> Int
    func placeOrder( orderList: [CartItemModel], address: String, fileURLS: [String]) -> AnyPublisher<DocumentReference, Error>
}


class UploadService {
    static let shared: UploadServiceProtocol = UploadService()
    
    private init() { }
}

extension UploadService : UploadServiceProtocol{
    
    func uploadFileToStorage( cartItems: [CartItemModel], completion: @escaping ( [String]? ) -> () ) {
        let storageRef = Storage.storage().reference()

        let mediaFolder = storageRef.child("uploaded")
        
        var count = 0
        var fileURLS = [String]()

        let semaphore = DispatchSemaphore(value: 0)
        
        // On background thread perform upload file function
        // semaphore helps us to notify which session should be completed
        // so semaphone.signal() gives a signal that perform an action
        // semaphone.wait() does not allow to pass the next line of the code until it is not completed
        
        DispatchQueue.global().async {
            
            for item in cartItems {

                let fileRef = mediaFolder.child("\(UUID().uuidString).pdf")
                
                fileRef.putFile(from: item.filePath, metadata: nil) { (metadata, error) in
                    if error != nil {
                        DispatchQueue.main.async {
                            completion( nil )
                        }

                        return
                    }
                    
                    fileRef.downloadURL { (url, error) in
                        if error != nil {
                            DispatchQueue.main.async {
                                completion( nil )
                            }
                            
                            return
                        }
                        
                        semaphore.signal()
                        fileURLS.append(url?.absoluteString ?? "")
                        count += 1
                        
                        if count == cartItems.count {
                            DispatchQueue.main.async {
                                completion( fileURLS )
                            }
                        }
                        

                    }
                }
                semaphore.wait()
            }
            
        }
        
    }
    
    func placeOrder( orderList: [CartItemModel], address: String, fileURLS: [String]) -> AnyPublisher<DocumentReference, Error> {
        let db = Firestore.firestore()

        var orders = [[String: Any]]()
        var totalPrice = 0
        for i in 0..<orderList.count {
            totalPrice += orderList[i].totalPrice
            
            orders.append([
                "productName" : orderList[i].category,
                "dimensions" : orderList[i].dimensions,
                "count" : orderList[i].count,
                "price" : orderList[i].totalPrice,
                "file" : fileURLS[i],
                "additionalInformation" : orderList[i].info
            ])
        }
        
        let orderDetails = [
            "totalPrice" : totalPrice,
            "address" : address
        ] as [String : Any]
        
        return ( db.collection("Orders").document(Auth.auth().currentUser!.phoneNumber!).collection("orders").addDocument(data: ["orderDetails" : orderDetails, "order" : orders]) as AnyPublisher<DocumentReference, Error>)
            .mapError{ $0 as Error }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func countPrice( count: Int, price: Int ) -> Int {
        return count * price
    }
    
}
