//
//  ContentView.swift
//  Online Printing
//
//  Created by Karen Mirakyan on 26.09.20.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var uploadVM = UploadViewModel()
    
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
                }.navigationBarTitle(Text( "OnlinePrinting" ), displayMode: .inline)            }
                

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
