//
//  UploadViewModel.swift
//  Online Printing
//
//  Created by Karen Mirakyan on 20.11.20.
//

import Foundation
import Combine

class UploadViewModel : ObservableObject {
    
    // Order Details
    @Published var info: String = ""
    @Published var count: String = ""
    @Published var size: String = ""
    @Published var sizePrice: String = ""
    @Published var fileName: String = ""
    @Published var address: String = ""
    @Published var path: URL? = nil
    @Published var selectedCategory: CategoryModel? = nil
    @Published var orderList = [CartItemModel]()
    
    // Alert
    @Published var activeAlert: ActiveAlert? = nil
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false
    
    // Loading
    @Published var loading: Bool = false
    @Published var buttonClickable: Bool = false
    
    @Published var countMessage: String = ""
    @Published var sizeMessage: String = ""
    @Published var fileMessage: String = ""
    
    private var cancellableSet: Set<AnyCancellable> = []

    
    init() {
        isCountPublisherValid
            .receive(on: RunLoop.main)
            .map { count in
                count ? "" : "Քանակը պարտադիր է"
            }
            .assign(to: \.countMessage, on: self)
            .store(in: &cancellableSet)

        
        isSizePublisherValid
            .receive(on: RunLoop.main)
            .map { size in
                size ? "" : "Չափը պարտադիր է"
            }
            .assign(to: \.sizeMessage, on: self)
            .store(in: &cancellableSet)
        
        isFileNamePublisherValid
            .receive(on: RunLoop.main)
            .map { file in
                file ? "" : "Ֆայլը ընտրված չէ"
            }
            .assign(to: \.fileMessage, on: self)
            .store(in: &cancellableSet)
        
        isButtonClickable
            .receive(on: RunLoop.main)
            .assign(to: \.buttonClickable, on: self)
            .store(in: &cancellableSet)
    }

    
    func placeOrder() {
        self.loading = true
        UploadService().uploadFileToStorage(cartItems: self.orderList, completion: { (response) in
            if let response = response {
                UploadService().placeOrder(orderList: self.orderList, address: self.address, fileURLS: response) { (orderPlacementResponse) in
                    if orderPlacementResponse == true {
                        self.orderList.removeAll(keepingCapacity: false)
                        self.loading = false
                        self.activeAlert = .placeCompleted
                        self.alertMessage = "Շնորհավորում ենք Ձեր պատվերը գրանցված է:"
                        self.showAlert = true
                    } else {
                        
                        self.loading = false
                        self.activeAlert = .error
                        self.alertMessage = "Ցավոք տեղի է ունեցել սխալ"
                        self.showAlert = true
                    }
                }
            }
        })
    }
    
    private var isCountPublisherValid: AnyPublisher<Bool, Never> {
        $count
            .debounce(for: 0.1, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { input in
                return input != ""
            }
            .eraseToAnyPublisher()
    }
    
    private var isFileNamePublisherValid: AnyPublisher<Bool, Never> {
        $fileName
            .map{ file in
                return file != ""
            }
            .eraseToAnyPublisher()
    }
    
    private var isSizePublisherValid: AnyPublisher<Bool, Never> {
        $size
            .map { size in
                return size != ""
            }
            .eraseToAnyPublisher()
    }
    
    private var isButtonClickable: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest3( isCountPublisherValid, isFileNamePublisherValid, isSizePublisherValid)
            .map { count, file, size in
                return count && file && size
            }
            .eraseToAnyPublisher()
    }
}
