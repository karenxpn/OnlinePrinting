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

class UploadService {
    let storageRef = Storage.storage().reference()
    let db = Firestore.firestore()
    
    
    func uploadFileToStorage( cartItems: [CartItemModel], completion: @escaping ( [String]? ) -> () ) {
        
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
    
    func placeOrder( orderList: [CartItemModel], fileURLS: [String], completion: @escaping ( Bool ) -> ()) {
        
        var orders = [[String: Any]]()
        for i in 0..<orderList.count {
            
            orders.append([
                "productName" : orderList[i].category,
                "dimensions" : orderList[i].dimensions,
                "count" : orderList[i].count,
                "price" : orderList[i].totalPrice,
                "file" : fileURLS[i],
                "additionalInformation" : orderList[i].info
            ])
        }
        
        // orderDetails should contain
        // user phone
        // order total Price
        // order address
        // etc
        
        
        db.collection("Orders").document("+37493936313").setData( ["order" : orders]) { error in
            if error != nil {
                DispatchQueue.main.async {
                    completion( false )
                }
                return
            }
            
            DispatchQueue.main.async {
                completion( true )
            }
        }
    }
    
    func countPrice( count: Int, price: Int ) -> Int {
        return count * price
    }
    
}
