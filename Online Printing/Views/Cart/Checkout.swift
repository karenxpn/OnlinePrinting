//
//  Checkout.swift
//  Online Printing
//
//  Created by Karen Mirakyan on 31.12.20.
//

import SwiftUI

struct Checkout: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var paymentVM: PaymentViewModel
    
    var body: some View {
        
        VStack {
            
            Button(action: {
                self.paymentVM.paymentMethod = "IDram"
            }, label: {
                HStack {
                    
                    Circle()
                        .strokeBorder(Color.black, lineWidth: 1)
                        .background(Circle().foregroundColor(self.paymentVM.paymentMethod == "IDram" ? Color.green : Color.white))
                        .frame(width: 16, height: 16)
                    
                    Image( "idram" )
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                    
                    Text( "IDram" )
                        .padding(.horizontal)
                        .foregroundColor(Color.black)
                    
                    Spacer()
                }
                
            })
            
            Button(action: {
                self.paymentVM.paymentMethod = "Bank Card"
            }, label: {
                HStack {
                    
                    Circle()
                        .strokeBorder(Color.black, lineWidth: 1)
                        .background(Circle().foregroundColor(self.paymentVM.paymentMethod == "Bank Card" ? Color.green : Color.white))
                        .frame(width: 16, height: 16)
                    
                    Image( "card" )
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                    Text( "Բանկային Քարտ" )
                        .padding(.horizontal)
                        .foregroundColor(Color.black)
                    
                    Spacer()
                }
            })
            
            Spacer()
            
            Button(action: {
                
                // check paymentmethod is empty or no
                
                if self.paymentVM.paymentMethod == "IDram" {
                    self.paymentVM.payWithIdram()
                } else {
                    // pay with bark card
                    self.paymentVM.initPayment()
                }
                self.paymentVM.navigateToCheckoutView.toggle()
                self.presentationMode.wrappedValue.dismiss()
                
            }, label: {
                Text("Վճարել")
            })
        }.padding()
    }
}
