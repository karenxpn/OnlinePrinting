//
//  SelectedCategory.swift
//  Online Printing
//
//  Created by Karen Mirakyan on 09.10.20.
//

import SwiftUI
import AlertX

struct SelectedCategory: View {
    
    @EnvironmentObject var uploadVM: UploadViewModel
    
    let category: CategoryModel
    @State private var openFile: Bool = false
    
    var body: some View {
        
        Form {
            
            Section(header: Text("Չափեր"), footer: Text(self.uploadVM.sizeMessage).foregroundColor(.red)) {
                SizeScroller(category: self.category).environmentObject( self.uploadVM )
            }
            
            Section(header: Text( "Քանակ" ) ,footer: Text(self.uploadVM.countMessage).foregroundColor(.red)) {
                TextField("Նշեք քանակը", text: self.$uploadVM.count)
                    .keyboardType(.numberPad)
            }
            
            Section(header: Text( "Հավելյալ նշումներ" ), footer: Text("(Optional)").foregroundColor(.gray)) {
                TextField("Հավելյալ Նշումներ", text: self.$uploadVM.info)
            }
            
            
            Section( footer: Text( self.uploadVM.fileMessage).foregroundColor(Color.red)) {
                ImportFile(openFile: self.$openFile)
                    .environmentObject(self.uploadVM)
            }
            
            CalculatePriceButton(category: self.category).environmentObject( self.uploadVM )
        }
        .fileImporter(isPresented: self.$openFile, allowedContentTypes: [.pdf], onCompletion: { (res) in
            do {
                
                let fileURL = try res.get()
                self.uploadVM.fileName = fileURL.lastPathComponent
                
                saveFile(url: fileURL)
                
            } catch {
                print(error.localizedDescription)
            }
        })
        .navigationBarTitle(Text(self.category.name), displayMode: .inline)
        
    }
    
    func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    
    func saveFile (url: URL) {
        if (CFURLStartAccessingSecurityScopedResource(url as CFURL)) {
            
            let fileData = try? Data.init(contentsOf: url)
            let fileName = url.lastPathComponent
            
            let actualPath = getDocumentsDirectory().appendingPathComponent(fileName)
            do {
                try fileData?.write(to: actualPath)
                if ( fileData == nil ) {
                    print("Permission error!")
                } else {
                    self.uploadVM.path = actualPath
                }
            } catch {
                print(error.localizedDescription)
            }
            CFURLStopAccessingSecurityScopedResource(url as CFURL)
        } else {
            print("Permission error!")
        }
    }
}

struct SizeScroller : View {
    
    let category: CategoryModel
    @EnvironmentObject var uploadVM: UploadViewModel
    
    var body: some View {
        
            ScrollView(.horizontal) {
                HStack {
                    ForEach( self.category.dimensions, id : \.id) { dimension in
                        
                        Button {
                            self.uploadVM.size = dimension.size
                            self.uploadVM.sizePrice = dimension.price
                        } label: {
                            VStack {
                                Image("dimens")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                                    .foregroundColor( self.uploadVM.size == dimension.size ? Color.black : Color.gray)
                                
                                Text( dimension.size )
                            }
                        }
                    }
                }
            }
    }
}

struct ImportFile: View {
    
    @EnvironmentObject var uploadVM: UploadViewModel
    @Binding var openFile: Bool
    
    var body: some View {
        Button {
            self.openFile.toggle()
        } label: {
            
            HStack {
                Spacer()
                if self.uploadVM.fileName == "" {
                    VStack {
                        Image("upload")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 150, height: 150)
                        
                        Text( "Ներբեռնել ֆայլը" )
                    }
                } else {
                    Text( self.uploadVM.fileName )
                }
                Spacer()
            }
        }
    }
}

struct CalculatePriceButton: View {
    
    @EnvironmentObject var uploadVM: UploadViewModel
    let category: CategoryModel
    
    var body: some View {
        Button {
            self.uploadVM.activeAlert = .dialog
            self.uploadVM.alertMessage = String( self.uploadVM.calculatePrice() )
            self.uploadVM.selectedCategory = self.category
            self.uploadVM.showAlert = true
        } label: {
            
            Text( "Հաշվարկել Գումարը" )
                .foregroundColor(Color.white)
                .padding()
            
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .background(self.uploadVM.buttonClickable ? Color.blue : Color.gray)
        .cornerRadius(10)
        .disabled(!self.uploadVM.buttonClickable)
    }
}
