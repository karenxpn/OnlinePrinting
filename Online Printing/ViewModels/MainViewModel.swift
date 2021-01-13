//
//  UploadViewModel.swift
//  Online Printing
//
//  Created by Karen Mirakyan on 20.11.20.
//

import Foundation
import Combine
import SwiftUI

class MainViewModel : ObservableObject {
    
    // Order Details
    @Published var info: String = ""
    @Published var count: String = ""
    @Published var size: String = ""
    @Published var price: Int = 0
    @Published var typeOfPrinting: String = ""  //oneSide or twoSide --- oneColor or twoColor
    @Published var fileName: String = ""
    @Published var address: String = ""
    @Published var path: URL? = nil
    @Published var selectedCategory: CategoryModel? = nil
    @Published var selectedCategorySpec: Specs? = nil
    @Published var additionalFunctionality: String = ""     //Lamination etc.
    @Published var orderList = [CartItemModel]()
    
    // PaymentDetails
    @Published var clientID: String = Credentials().clientID
    @Published var username: String = Credentials().username
    @Published var password: String = Credentials().password
    
    @Published var paymentID: String = ""
    @Published var description: String = ""
    @Published var orderID: Int = 0
    @Published var totalAmount: Decimal = 0
    @Published var paymentDetails: PaymentDetailsResponse? = nil
    
    @Published var navigateToCheckoutView: Bool = false     // view to chose payment method
    @Published var paymentMethod: String = ""               // IDram or Bank Card
    @Published var showWeb: Bool = false
    @Published var payButtonClickable: Bool = false
 
    // Alert
    @Published var activeAlert: ActiveAlert? = nil
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false
    
    // Loading
    @Published var loading: Bool = false
    @Published var buttonClickable: Bool = false
    
    // Section footer messages
    @Published var countMessage: String = ""
    @Published var specsMessage: String = ""
    @Published var fileMessage: String = ""
    
    private var cancellableSet: Set<AnyCancellable> = []
    var dataManager: UploadServiceProtocol
    var paymentDataManager: PaymentServiceProtocol
    
    init(dataManager: UploadServiceProtocol = UploadService.shared,
         paymentDataManager: PaymentServiceProtocol = PaymentService.shared) {
        
        self.dataManager = dataManager
        self.paymentDataManager = paymentDataManager
        
        isSpecsPublisherValid
            .receive(on: RunLoop.main)
            .map { size in
                size ? "" : "Այս դաշտերը պարտադիր են"
            }
            .assign(to: \.specsMessage, on: self)
            .store(in: &cancellableSet)
        
        isCountPublisherValid
            .receive(on: RunLoop.main)
            .map { count in
                if self.selectedCategorySpec != nil {
                    return count ? "" : "Մինիմալ պատվերի քանակը: \(self.selectedCategorySpec!.minBorderCount)"
                } else {
                    return count ? "" : "Քանակը պարտադիր է"
                }
            }
            .assign(to: \.countMessage, on: self)
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
        
        isPayButtonClickable
            .receive(on: RunLoop.main)
            .assign(to: \.payButtonClickable, on: self)
            .store(in: &cancellableSet)
    }
    
    
    private var isCountPublisherValid: AnyPublisher<Bool, Never> {
        $count
            .debounce(for: 0.1, scheduler: RunLoop.main)
            .map { input in
                return input != "" && Int( input ) ?? 0 >= self.selectedCategorySpec!.minBorderCount
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
    
    private var isTypePublisherValid: AnyPublisher<Bool, Never> {
        $typeOfPrinting
            .map { type in
                return type != ""
            }
            .eraseToAnyPublisher()
    }
    
    private var isSpecsPublisherValid: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(isSizePublisherValid, isTypePublisherValid)
            .map {type, size in
                return type && size
            }
            .eraseToAnyPublisher()
    }
    
    private var isButtonClickable: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest3( isCountPublisherValid, isFileNamePublisherValid, isSpecsPublisherValid)
            .map { count, file, size in
                return count && file && size
            }
            .eraseToAnyPublisher()
    }
    
    private var isPayButtonClickable: AnyPublisher<Bool, Never> {
        $paymentMethod
            .map { paymentMethod in
                return paymentMethod != ""
            }
            .eraseToAnyPublisher()
    }
}


extension MainViewModel {
    
    func placeOrder() {
        self.loading = true
        dataManager.uploadFileToStorage(cartItems: self.orderList) { (response) in
            if let response = response {
                self.dataManager.placeOrder(orderList: self.orderList, address: self.address, fileURLS: response) { (uploadResponse) in
                    if uploadResponse == true {
                        self.orderList.removeAll(keepingCapacity: false)
                        self.loading = false
                        self.activeAlert = .placementCompleted
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
        }
    }
    
    // Payment Part
    
    func payWithIdram() {
        paymentDataManager.calculateTotalAmount(products: self.orderList, completion: { amount in
            self.paymentDataManager.payWithIdram(amount: amount)
        })
    }
    
    func initPayment() {
        paymentDataManager.updateOrderID { (updateResponse) in
            if let orderID = updateResponse {
                self.orderID = orderID
                
                self.paymentDataManager.calculateTotalAmount(products: self.orderList) { (amount) in
                    self.totalAmount = Decimal(amount)
                    
                    let model = InitPaymentRequest(ClientID: self.clientID, Username: self.username, Password: self.password, Currency: nil, Description: self.description, OrderID: self.orderID, Amount: 10, BackURL: nil, Opaque: nil, CardHolderID: nil)
                    
                    self.paymentDataManager.initPayment(model: model) { [self] (initPaymentResponse) in
                        if let response = initPaymentResponse {
                            if response.ResponseCode == 1 {
                                self.paymentID = response.PaymentID
                                self.showWeb.toggle()
                                // open payment webpage
                                // open url can only called on tap
                                // on condition it is called only from viewmodel
                                // open payment webpage

                            } else {
                                self.activeAlert = .error
                                self.alertMessage = response.ResponseMessage
                                self.showAlert.toggle()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getResponse() {
        
        let model = PaymentDetailsRequest(PaymentID: self.paymentID, Username: self.username, Password: self.password)
        paymentDataManager.getPaymentDetails(model: model) { (response) in
            if let response = response {
                print(response)
                self.paymentDetails = response
                
                if response.ResponseCode == "00" {
                
                    // Place order here
                    self.placeOrder()

                } else {
                    self.activeAlert = .error
                    self.alertMessage = response.Description
                    self.showAlert.toggle()
                }
            }
        }
    }
    
    
    // calculate single category order price when user clickes to calculate order button
    func calculatePrice( category: CategoryModel ) {
        
        dataManager.calculateAmount(selectedCategorySpecs: self.selectedCategorySpec!, count: Int( self.count )!, typeOfPrinting: self.typeOfPrinting, additionalFunctionalityTitle: self.additionalFunctionality) { (amount) in
            
            self.activeAlert = .dialog
            self.alertMessage = String( amount )
            self.selectedCategory = category
            self.showAlert = true
        }
    }
}
