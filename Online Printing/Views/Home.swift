//
//  Home.swift
//  Online Printing
//
//  Created by Karen Mirakyan on 08.12.20.
//

import SwiftUI

struct Home: View {
    @ObservedObject var mainVM = MainViewModel()
    @EnvironmentObject var uploadVM: UploadViewModel

    
    var body: some View {
        
        if self.mainVM.loading {
            Loading()
        } else {
            ScrollView {
                
                LazyVStack {
                    ForEach( self.mainVM.categories) { category in
                        
                        NavigationLink(
                            destination: SelectedCategory(category: category).environmentObject(self.uploadVM),
                            label: {
                                SingleCategoryPreview(category: category)
                            })
                    }
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
