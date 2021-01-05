//
//  SingleCategoryPreview.swift
//  Online Printing
//
//  Created by Karen Mirakyan on 09.10.20.
//

import SwiftUI
import SDWebImageSwiftUI

struct SingleCategoryPreview: View {
    
    let category: CategoryModel
    
    var body: some View {
        VStack {
            ZStack {
                
                WebImage(url: URL(string: category.image))
                    .resizable()
                    .scaledToFill()
                    .cornerRadius(20)
                
            }.padding()
        }
        .background(Color.white)
        .cornerRadius(20)
        .padding([.top, .horizontal], 20)
        .shadow(color: Color.gray, radius: 8, x: 8, y: 8)
        .shadow(color: Color.black, radius: 8, x: -8, y: -8)
    }
}
