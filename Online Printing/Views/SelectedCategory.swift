//
//  SelectedCategory.swift
//  Online Printing
//
//  Created by Karen Mirakyan on 09.10.20.
//

import SwiftUI

enum ActiveAlert {
    case error, dialog
}

struct SelectedCategory: View {
    
    @EnvironmentObject var uploadVM: UploadViewModel
    
    let category: CategoryModel
    @State private var openFile: Bool = false
    @State private var alert: Bool = false
    
    var body: some View {
        
        if self.uploadVM.loading {
            Loading()
        } else {
            VStack( spacing: 20) {
                
                SizeScroller(category: self.category).environmentObject( self.uploadVM )
                
                TextField("Նշեք քանակը", text: self.$uploadVM.count)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                
                
                TextField("Հավելյալ Նշումներ", text: self.$uploadVM.info)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                
                Button {
                    
                    self.openFile.toggle()
                    
                } label: {
                    
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
                    
                }
                
                Button {
                    if self.uploadVM.size == "" || self.uploadVM.count == "" || self.uploadVM.fileName == "" {
                        self.uploadVM.activeAlert = .error
                        self.uploadVM.alertMessage = "Fill in all required fields"
                        self.alert.toggle()
                    } else {
                        self.uploadVM.activeAlert = .dialog
                        self.uploadVM.alertMessage = "\(UploadService().countPrice(count: Int( self.uploadVM.count )!, price: Int( self.uploadVM.sizePrice )!))"
                        self.alert.toggle()
                    }
                } label: {
                    
                    Text( "Հաշվարկել Գումարը" )
                        .foregroundColor(Color.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(30)
                }
                
                Spacer()
                
            }.padding()
            .fileImporter(isPresented: self.$openFile, allowedContentTypes: [.pdf], onCompletion: { (res) in
                do {
                    
                    let fileURL = try res.get()
                    self.uploadVM.fileName = fileURL.lastPathComponent
                    
                    saveFile(url: fileURL)
                    
                } catch {
                    print( "Error reading document" )
                    print(error.localizedDescription)
                }
            })
            .alert(isPresented: self.$alert, content: {
                if self.uploadVM.activeAlert == .dialog {
                    return Alert(title: Text( "Amount is" ), message: Text( "\(self.uploadVM.alertMessage) AMD" ), primaryButton: .destructive(Text( "Ավելացնել զամբյուղի մեջ" ), action: {
                        let cartModel = CartItemModel(dimensions: self.uploadVM.size, count: Int( self.uploadVM.count )!, totalPrice: Int( self.uploadVM.alertMessage )!, category: self.category.name, image: self.category.image, filePath: self.uploadVM.path!)
                        
                        self.uploadVM.orderList.append(cartModel)
                        
                        self.uploadVM.path = nil
                        self.uploadVM.fileName = ""
                        self.uploadVM.info = ""
                        self.uploadVM.count = ""
                        self.uploadVM.size = ""
                        self.uploadVM.sizePrice = ""
                        
                    }), secondaryButton: .cancel())
                } else {
                    return Alert(title: Text( "Alert" ), message: Text( self.uploadVM.alertMessage ), dismissButton: .default(Text( "OK" )))
                }

            })
            .navigationBarTitle(Text(self.category.name), displayMode: .inline)
        }
        
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


