//
//  ContentView.swift
//  Online Printing
//
//  Created by Karen Mirakyan on 26.09.20.
//

import SwiftUI
import AlertX

enum ActiveAlert {
    case error, dialog, placementCompleted, paymentError, paymentSuccess
}

struct ContentView: View {
    
    @EnvironmentObject var mainVM: MainViewModel
    @EnvironmentObject var authVM: AuthViewModel
    @State private var selectedTab = 0
    
    var body: some View {

        NavigationView {
            
            if self.mainVM.loading {
                Loading()
            } else {
                ZStack ( alignment: .bottomLeading) {
                    TabView( selection: $selectedTab) {
                        
                        Home()
                            .environmentObject(self.mainVM)
                            .tabItem {
                                Image(systemName: "house")
                                Text("Home")
                            }
                            .tag( 0 )
                        
                        Cart()
                            .environmentObject(self.mainVM)
                            .environmentObject( self.authVM )
                            .tabItem {
                                Image(systemName: "cart")
                                Text("Cart")
                            }
                            .tag( 1 )
                    }
                    
                    ZStack {
                        Circle()
                            .foregroundColor(.red)
                        
                        Text("\(self.mainVM.orderList.count)")
                            .foregroundColor(.white)
                            .font(Font.system(size: 12))
                    }
                    .frame(width: 15, height: 15)
                    .offset(x: ( ( 2 * 2) - 1 ) * ( UIScreen.main.bounds.size.width / ( 2 * 2 ) ), y: -30)
                    .opacity(2 == 0 ? 0 : 1)
                }
                .navigationBarTitle( self.selectedTab == 0 ? Text( "Home" ) : Text( "Cart" ), displayMode: .inline)
                .navigationBarItems(trailing: self.selectedTab == 1 ?
                                    AnyView( Button(action: {
                                        self.authVM.logOutUser()
                                    }, label: {
                                        Text("Sign Out")
                                            .font(.custom("McLaren-Regular", size: 16))
                                    })) : AnyView( EmptyView() ))
            }
            
        }.alertX(isPresented: self.$mainVM.showAlert) {
            if self.mainVM.activeAlert == .dialog {
                
                return AlertX(title: Text( "Շնորհակալություն" ), message: Text( "Ձեր ընտրված ապրանքի գումարը կազմում է: \(self.mainVM.alertMessage) AMD" ), primaryButton: .default(Text("Add to Cart"), action: {
                    
                    let cartModel = CartItemModel(dimensions: self.mainVM.size, count: Int( self.mainVM.count )!, totalPrice: Int( self.mainVM.alertMessage )!, info: self.mainVM.info, category: self.mainVM.selectedCategory!.name, image: self.mainVM.selectedCategory!.image, filePath: self.mainVM.path!, additionalFunctionality: self.mainVM.additionalFunctionality, oneSide_Color_bothSide_ColorPrinting: self.mainVM.typeOfPrinting)
                    
                    self.mainVM.orderList.append(cartModel)
                    
                    self.mainVM.path = nil
                    self.mainVM.fileName = ""
                    self.mainVM.info = ""
                    self.mainVM.count = ""
                    self.mainVM.size = ""
                    self.mainVM.price = 0
                    self.mainVM.typeOfPrinting = ""
                    self.mainVM.selectedCategorySpec = nil
                    self.mainVM.selectedCategory = nil
                    self.mainVM.additionalFunctionality = ""
                    
                }), secondaryButton: .cancel(), theme: AlertX.Theme.custom(windowColor: Color(UIColor(red: 17/255, green: 83/255, blue: 252/255, alpha: 0.5)),
                                                                           alertTextColor: Color.white,
                                                                           enableShadow: true,
                                                                           enableRoundedCorners: true,
                                                                           enableTransparency: true,
                                                                           cancelButtonColor: Color(UIColor(red: 17/255, green: 83/255, blue: 252/255, alpha: 1)),
                                                                           cancelButtonTextColor: Color.white,
                                                                           defaultButtonColor: Color(UIColor(red: 17/255, green: 83/255, blue: 252/255, alpha: 1)), defaultButtonTextColor: Color.white),
                            animation: .zoomEffect())
                
                
            } else if self.mainVM.activeAlert == .placementCompleted {
                return AlertX(title: Text( "Շնորհակալություն" ), message: Text( self.mainVM.alertMessage ), primaryButton: .default(Text( "OK" ), action: {
                    self.mainVM.activeAlert = nil
                    self.mainVM.alertMessage = ""
                }), theme: AlertX.Theme.custom(windowColor: Color(UIColor(red: 17/255, green: 83/255, blue: 252/255, alpha: 0.5)),
                                               alertTextColor: Color.white,
                                               enableShadow: true,
                                               enableRoundedCorners: true,
                                               enableTransparency: true,
                                               cancelButtonColor: Color(UIColor(red: 17/255, green: 83/255, blue: 252/255, alpha: 1)),
                                               cancelButtonTextColor: Color.white,
                                               defaultButtonColor: Color(UIColor(red: 17/255, green: 83/255, blue: 252/255, alpha: 1)), defaultButtonTextColor: Color.white),
                            animation: .zoomEffect())
                
            } else {
                return AlertX(title: Text( "Սխալ" ), message: Text( self.mainVM.alertMessage ), primaryButton: .default(Text( "Լավ" )), theme: AlertX.Theme.custom(windowColor: Color(UIColor(red: 17/255, green: 83/255, blue: 252/255, alpha: 0.5)),
                                        alertTextColor: Color.white,
                                        enableShadow: true,
                                        enableRoundedCorners: true,
                                        enableTransparency: true,
                                        cancelButtonColor: Color(UIColor(red: 17/255, green: 83/255, blue: 252/255, alpha: 1)),
                                        cancelButtonTextColor: Color.white,
                                        defaultButtonColor: Color(UIColor(red: 17/255, green: 83/255, blue: 252/255, alpha: 1)), defaultButtonTextColor: Color.white),
                              animation: .zoomEffect())
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
