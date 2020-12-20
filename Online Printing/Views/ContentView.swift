//
//  ContentView.swift
//  Online Printing
//
//  Created by Karen Mirakyan on 26.09.20.
//

import SwiftUI
import AlertX

struct ContentView: View {
    
    @ObservedObject var uploadVM = UploadViewModel()
    @ObservedObject var authVM = AuthViewModel()
    
    var body: some View {
        
        NavigationView {
            
            if self.uploadVM.loading {
                Loading()
            } else {
                ZStack ( alignment: .bottomLeading) {
                    TabView {
                        
                        Home()
                            .environmentObject(self.uploadVM)
                            .tabItem {
                                Image(systemName: "house")
                                Text("Home")
                            }
                        
                        Cart()
                            .environmentObject(self.uploadVM)
                            .environmentObject( self.authVM )
                            .tabItem {
                                Image(systemName: "cart")
                                Text("Cart")
                                
                            }
                    }
                    
                    ZStack {
                        Circle()
                            .foregroundColor(.red)
                        
                        Text("\(self.uploadVM.orderList.count)")
                            .foregroundColor(.white)
                            .font(Font.system(size: 12))
                    }
                    .frame(width: 15, height: 15)
                    .offset(x: ( ( 2 * 2) - 1 ) * ( UIScreen.main.bounds.size.width / ( 2 * 2 ) ), y: -30)
                    .opacity(2 == 0 ? 0 : 1)
                }.navigationBarTitle(Text( "OnlinePrinting" ), displayMode: .inline)
                .navigationBarItems(trailing:
                                        Button(action: {
                                            self.authVM.logOutUser()
                                        }, label: {
                                            Text("Sign Out")
                                        })
                )
            }
            
            
        }.alertX(isPresented: self.$uploadVM.showAlert) {
            if self.uploadVM.activeAlert == .dialog {
                
                return AlertX(title: Text( "Amount is" ), message: Text( "\(self.uploadVM.alertMessage) AMD" ), primaryButton: .default(Text("Ավելացնել Զամբյուղ"), action: {
                    let cartModel = CartItemModel(dimensions: self.uploadVM.size, count: Int( self.uploadVM.count )!, totalPrice: Int( self.uploadVM.alertMessage )!, info: self.uploadVM.info, category: self.uploadVM.selectedCategory!.name, image: self.uploadVM.selectedCategory!.image, filePath: self.uploadVM.path!)
                    
                    self.uploadVM.orderList.append(cartModel)
                    
                    self.uploadVM.path = nil
                    self.uploadVM.fileName = ""
                    self.uploadVM.info = ""
                    self.uploadVM.count = ""
                    self.uploadVM.size = ""
                    self.uploadVM.sizePrice = ""
                }), secondaryButton: .cancel(), theme: AlertX.Theme.custom(windowColor: Color(UIColor(red: 17/255, green: 83/255, blue: 252/255, alpha: 0.5)),
                                                                           alertTextColor: Color.white,
                                                                           enableShadow: true,
                                                                           enableRoundedCorners: true,
                                                                           enableTransparency: true,
                                                                           cancelButtonColor: Color(UIColor(red: 17/255, green: 83/255, blue: 252/255, alpha: 1)),
                                                                           cancelButtonTextColor: Color.white,
                                                                           defaultButtonColor: Color(UIColor(red: 17/255, green: 83/255, blue: 252/255, alpha: 1)), defaultButtonTextColor: Color.white),
                animation: .defaultEffect())
                
                
            } else if self.uploadVM.activeAlert == .placeCompleted {
                return AlertX(title: Text( "Շնորհավորում ենք" ), message: Text( self.uploadVM.alertMessage ), primaryButton: .default(Text( "OK" ), action: {
                    self.uploadVM.activeAlert = nil
                    self.uploadVM.alertMessage = ""
                }), theme: AlertX.Theme.custom(windowColor: Color(UIColor(red: 17/255, green: 83/255, blue: 252/255, alpha: 0.5)),
                                               alertTextColor: Color.white,
                                               enableShadow: true,
                                               enableRoundedCorners: true,
                                               enableTransparency: true,
                                               cancelButtonColor: Color(UIColor(red: 17/255, green: 83/255, blue: 252/255, alpha: 1)),
                                               cancelButtonTextColor: Color.white,
                                               defaultButtonColor: Color(UIColor(red: 17/255, green: 83/255, blue: 252/255, alpha: 1)), defaultButtonTextColor: Color.white),
                animation: .defaultEffect())
                
            } else {
                return AlertX(title: Text( "Սխալ" ), message: Text( self.uploadVM.alertMessage ), primaryButton: .default(Text( "Լավ" )), theme: AlertX.Theme.custom(windowColor: Color(UIColor(red: 17/255, green: 83/255, blue: 252/255, alpha: 0.5)),
                                        alertTextColor: Color.white,
                                        enableShadow: true,
                                        enableRoundedCorners: true,
                                        enableTransparency: true,
                                        cancelButtonColor: Color(UIColor(red: 17/255, green: 83/255, blue: 252/255, alpha: 1)),
                                        cancelButtonTextColor: Color.white,
                                        defaultButtonColor: Color(UIColor(red: 17/255, green: 83/255, blue: 252/255, alpha: 1)), defaultButtonTextColor: Color.white),
                              animation: .defaultEffect())
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
