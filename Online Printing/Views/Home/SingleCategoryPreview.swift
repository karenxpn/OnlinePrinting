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

//struct SingleCategoryPreview_Previews: PreviewProvider {
//    static var previews: some View {
//        SingleCategoryPreview(category: CategoryModel(name: "Printing", image: "https://firebasestorage.googleapis.com/v0/b/flyshop-4e6ea.appspot.com/o/giordano-logo.png?alt=media&token=1f062543-74ce-4a00-b435-8049df0cf1e0", specs: [Specs(name: "A4", oneSide_ColorPrice: 150, bothSide_ColorPrice: 200, minCount: 100, minCountDiscount: 10, averageCount: 500, averageCountDiscount: 20, maxCount: 1000, maxCountDiscount: 30, additionalFunctionality: [AdditionalFunctionality(functionalityTitle: "Laminacia", functionalityAdditionalPrice: 100)], minBorderCount: 1)]))
//    }
//}
