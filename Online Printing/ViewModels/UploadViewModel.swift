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
    @Published var price: Int = 0
    @Published var typeOfPrinting: String = ""  //oneSide or twoSide --- oneColor or twoColor
    @Published var fileName: String = ""
    @Published var address: String = ""
    @Published var path: URL? = nil
    @Published var selectedCategory: CategoryModel? = nil
    @Published var selectedCategorySpec: Specs? = nil
    @Published var additionalFunctionality: String = ""     //Lamination etc.
    @Published var orderList = [CartItemModel]()
    
    // Alert
    @Published var activeAlert: ActiveAlert? = nil
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false
    
    // Loading
    @Published var loading: Bool = false
    @Published var buttonClickable: Bool = false
    
    @Published var countMessage: String = ""
    @Published var specsMessage: String = ""
    @Published var fileMessage: String = ""
    
    private var cancellableSet: Set<AnyCancellable> = []
    var dataManager: UploadServiceProtocol

    
    init(dataManager: UploadServiceProtocol = UploadService.shared) {
        self.dataManager = dataManager
        
        isCountPublisherValid
            .receive(on: RunLoop.main)
            .map { count in
                count ? "" : "Այս դաշտը պարտադիր են"
            }
            .assign(to: \.countMessage, on: self)
            .store(in: &cancellableSet)

        
        isSpecsPublisherValid
            .receive(on: RunLoop.main)
            .map { size in
                size ? "" : "Չափը պարտադիր է"
            }
            .assign(to: \.specsMessage, on: self)
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
    
    private var isCountPublisherValid: AnyPublisher<Bool, Never> {
        $count
            .debounce(for: 0.1, scheduler: RunLoop.main)
            .removeDuplicates()
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
}


extension UploadViewModel {
    func placeOrder() {
        self.loading = true
        dataManager.uploadFileToStorage(cartItems: self.orderList) { (response) in
            if let response = response {
                self.dataManager.placeOrder(orderList: self.orderList, address: self.address, fileURLS: response)
                    .sink { (completion) in
                        switch completion {
                            case .finished:
                                self.orderList.removeAll(keepingCapacity: false)
                                self.loading = false
                                self.activeAlert = .placementCompleted
                                self.alertMessage = "Շնորհավորում ենք Ձեր պատվերը գրանցված է:"
                                self.showAlert = true
                            case .failure( _ ):
                                self.loading = false
                                self.activeAlert = .error
                                self.alertMessage = "Ցավոք տեղի է ունեցել սխալ"
                                self.showAlert = true
                        }
                    } receiveValue: { (docRef) in
                        print(docRef)
                    }
                    .store(in: &self.cancellableSet)

            }
        }
    }
    
    func calculatePrice( category: CategoryModel ){
        
        dataManager.calculateAmount(selectedCategorySpecs: self.selectedCategorySpec!, count: Int( self.count )!, typeOfPrinting: self.typeOfPrinting, additionalFunctionalityTitle: self.additionalFunctionality) { (amount) in
            
            self.activeAlert = .dialog
            self.alertMessage = "\(amount)AMD"
            self.selectedCategory = category
            self.showAlert = true
        }
    }
}
