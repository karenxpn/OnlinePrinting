//
//  Checkout.swift
//  Online Printing
//
//  Created by Karen Mirakyan on 08.12.20.
//

import SwiftUI
import FirebaseAuth
import SDWebImageSwiftUI
import IdramMerchantPayment

enum ActiveSheet {
    case auth, payment
}

struct Cart: View {
    
    @EnvironmentObject var uploadVM: UploadViewModel
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var paymentVM: PaymentViewModel
    @State private var activeSheet: ActiveSheet? = nil
    
    var body: some View {
        
        VStack {
            
            List {
                ForEach( self.uploadVM.orderList, id: \.id ) { order in
                    
                    HStack {
                        WebImage(url: URL(string: order.image))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .cornerRadius(20)
                        
                        Spacer()
                        
                        VStack( alignment: .leading) {
                            Text( "Category: \(order.category)" )
                            Text( "Dimensions: \(order.dimensions)" )
                            Text( "Count: \(order.count)" )
                            Text( "Total Price: \(order.totalPrice)" )
                        }
                    }.padding( .horizontal, 8 )
                }.onDelete(perform: delete)
            }
            
            Button(action: {
                if Auth.auth().currentUser == nil {
                    self.activeSheet = .auth
                    self.authVM.showSeet.toggle()
                } else if self.uploadVM.orderList.isEmpty {
                    self.uploadVM.activeAlert = .error
                    self.uploadVM.alertMessage = "Զամբյուղը դատարկ է:"
                    self.uploadVM.showAlert = true
                } else {
                    self.dialog()
                }
            }, label: {
                Text( "Գրանցել Պատվեր" )
                    .foregroundColor(Color.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(30)
            }).padding(.bottom, 10)
            
            NavigationLink(destination: Checkout().environmentObject(self.paymentVM), isActive: self.$paymentVM.navigateToCheckoutView) {
                EmptyView()
            }
            
            NavigationLink(destination: BankPayment().environmentObject(self.paymentVM), isActive: self.$paymentVM.openPayment) {
                EmptyView()
            }
        }.alert(isPresented: self.$paymentVM.showAlert) {
            
            // Customize alert
            Alert(title: Text( self.paymentVM.alertTitle), message: Text( self.paymentVM.alertMessage ), dismissButton: .default(Text( "OK" )))
        }
        .sheet(isPresented: self.$authVM.showSeet, content: {
                AuthView()
                    .environmentObject(self.authVM)
        })

    }
    
    func delete(at offsets: IndexSet) {
        self.uploadVM.orderList.remove(atOffsets: offsets)
    }
    
    func dialog(){
        
        let alertController = UIAlertController(title: "Address", message: "Մուտքագրեք հասցեն:", preferredStyle: .alert)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Մուտքագրեք հասցեն"
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil )
        
        let saveAction = UIAlertAction(title: "Done", style: .default, handler: { alert -> Void in
            
            let secondTextField = alertController.textFields![0] as UITextField
            if secondTextField.text == "" {
                self.uploadVM.activeAlert = .error
                self.uploadVM.alertMessage = "Մուտքագրեք հասցեն"
                self.uploadVM.showAlert = true
            } else {
                self.uploadVM.address = secondTextField.text ?? "Invalid Address"
                
                self.paymentVM.products = self.uploadVM.orderList
                self.paymentVM.navigateToCheckoutView.toggle()
            }
        })
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)

        UIApplication.shared.windows.first?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
}
