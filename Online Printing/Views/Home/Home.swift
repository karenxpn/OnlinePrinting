//
//  Home.swift
//  Online Printing
//
//  Created by Karen Mirakyan on 08.12.20.
//

import SwiftUI

struct Home: View {
    @StateObject var categoryVM = CategoryViewModel()
    @EnvironmentObject var mainVM: MainViewModel
    
    var body: some View {
        
        ScrollView {
            
            LazyVStack {
                ForEach( self.categoryVM.categories ) { category in
                    
                    NavigationLink(
                        destination: SelectedCategory(category: category).environmentObject(self.mainVM),
                        label: {
                            SingleCategoryPreview(category: category)
                        })
                }
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
