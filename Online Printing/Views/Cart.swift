//
//  Checkout.swift
//  Online Printing
//
//  Created by Karen Mirakyan on 08.12.20.
//

import SwiftUI
import SDWebImageSwiftUI

struct Cart: View {
    
    @EnvironmentObject var uploadVM: UploadViewModel
    
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
                    }.padding( .horizontal )
                }.onDelete(perform: delete)
            }
            
            Button(action: {
                
                uploadVM.placeOrder()
                
            }, label: {
                Text( "Գրանցել Պատվեր" )
                    .foregroundColor(Color.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(30)
            })
        }
        
    }
    
    func delete(at offsets: IndexSet) {
        self.uploadVM.orderList.remove(atOffsets: offsets)
        }
}

struct Checkout_Previews: PreviewProvider {
    static var previews: some View {
        Cart()
    }
}
