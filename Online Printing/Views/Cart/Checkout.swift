//
//  Checkout.swift
//  Online Printing
//
//  Created by Karen Mirakyan on 31.12.20.
//

import SwiftUI

struct Checkout: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var mainVM: MainViewModel
    
    var body: some View {
        
        VStack {
            
            Button(action: {
                self.mainVM.paymentMethod = "IDram"
            }, label: {
                HStack {
                    
                    Circle()
                        .strokeBorder(Color.black, lineWidth: 1)
                        .background(Circle().foregroundColor(self.mainVM.paymentMethod == "IDram" ? Color.green : Color.white))
                        .frame(width: 16, height: 16)
                    
                    Image( "idram" )
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .cornerRadius(8)
                    
                    Text( "IDram" )
                        .padding(.horizontal)
                        .foregroundColor(Color.black)
                    
                    Spacer()
                }
                
            })
            
            Button(action: {
                self.mainVM.paymentMethod = "Bank Card"
            }, label: {
                HStack {
                    
                    Circle()
                        .strokeBorder(Color.black, lineWidth: 1)
                        .background(Circle().foregroundColor(self.mainVM.paymentMethod == "Bank Card" ? Color.green : Color.white))
                        .frame(width: 16, height: 16)
                    
                    Image( "card" )
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                    Text( "Բանկային Քարտ" )
                        .padding(.horizontal)
                        .foregroundColor(Color.black)
                    
                    Text("Շուտով")
                        .foregroundColor(.gray)
                        .font(.system(size: 18))
                    
                    Spacer()
                }
            }).disabled(true)
            
            Spacer()
            
            Button(action: {
                                
                if self.mainVM.paymentMethod == "IDram" {
                    // pay with idram
                    self.mainVM.payWithIdram()
                } else {
                    // pay with bark card
                    self.mainVM.initPayment()
                }
                self.mainVM.navigateToCheckoutView.toggle()
                self.presentationMode.wrappedValue.dismiss()
                
            }, label: {
                Text("Վճարել")
                    .foregroundColor(Color.white)
                    .padding()

            }).background(self.mainVM.payButtonClickable ? Color.blue : Color.gray)
            .cornerRadius(30)
            .disabled(!self.mainVM.payButtonClickable)
        }.padding(.horizontal, 20)
        .padding(.vertical)
    }
}
