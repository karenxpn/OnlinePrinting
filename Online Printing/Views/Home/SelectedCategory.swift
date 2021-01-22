//
//  SelectedCategory.swift
//  Online Printing
//
//  Created by Karen Mirakyan on 09.10.20.
//

import SwiftUI
import AlertX
import SDWebImageSwiftUI
import WidgetKit

struct SelectedCategory: View {
    
    @EnvironmentObject var mainVM: MainViewModel
    
    let category: CategoryModel
    @State private var openFile: Bool = false
    
        
    var body: some View {
        
        Form {
            
            Section(header: Text("Չափեր"), footer: Text(self.mainVM.specsMessage).foregroundColor(.red)) {
                SizeScroller(category: self.category).environmentObject( self.mainVM )
                
                if self.mainVM.selectedCategorySpec != nil {
                    Picker(self.mainVM.typeOfPrinting == "" ? "Ընտրել Տպաքրության տեսակը" : self.mainVM.typeOfPrinting, selection: self.$mainVM.typeOfPrinting) {
                        
                        Text( self.mainVM.selectedCategorySpec!.typeUnit == "Color" ? "Մի գույն" : "Մի կողմանի" )
                            .tag( self.mainVM.selectedCategorySpec!.typeUnit == "Color" ? "Մի գույն" : "Մի կողմանի" )
                        
                        Text( self.mainVM.selectedCategorySpec!.typeUnit == "Color" ? "Երկու գույն" : "Երկու կողմանի" )
                            .tag( self.mainVM.selectedCategorySpec!.typeUnit == "Color" ? "Երկու գույն" : "Երկու կողմանի" )
                        
                    }.pickerStyle(MenuPickerStyle())
                    .foregroundColor(Color( UIColor.systemGray2 ).opacity(0.7))
                }
            }
            
            Section(header: Text( "Քանակ" ) ,footer: Text(self.mainVM.countMessage).foregroundColor(.red)) {
                TextField(self.mainVM.selectedCategorySpec == nil ? "Նշեք քանակը" : self.mainVM.selectedCategorySpec!.measurementUnit, text: self.$mainVM.count)
                    .keyboardType(.numberPad)
            }
            
            Section(header: Text( "Հավելյալ նշումներ" ), footer: Text("(Optional)").foregroundColor(.gray)) {
                TextField("Հավելյալ Նշումներ", text: self.$mainVM.info)
                
                if self.mainVM.selectedCategorySpec != nil {
                    Picker( self.mainVM.additionalFunctionality == "" ? "Հավելյալ պահանջներ" : self.mainVM.additionalFunctionality, selection: self.$mainVM.additionalFunctionality) {
                        ForEach( self.mainVM.selectedCategorySpec!.additionalFunctionality, id: \.id ) { functionality in
                            Text( functionality.functionalityTitle ).tag( functionality.functionalityTitle )
                        }
                    }.pickerStyle(MenuPickerStyle())
                    .foregroundColor(Color( UIColor.systemGray2 ).opacity(0.7))
                }
            }
            
            
            Section( footer: Text( self.mainVM.fileMessage).foregroundColor(Color.red)) {
                ImportFile(openFile: self.$openFile)
                    .environmentObject(self.mainVM)
            }
            
            CalculatePriceButton(category: self.category).environmentObject( self.mainVM )
            
        }.onAppear {
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
            
            self.mainVM.storeLastVisitedCategory(category: self.category)
        }.gesture(DragGesture().onChanged { _ in
            UIApplication.shared.windows.forEach { $0.endEditing(false) }
        })
        .fileImporter(isPresented: self.$openFile, allowedContentTypes: [.pdf], onCompletion: { (res) in
            do {
                
                let fileURL = try res.get()
                self.mainVM.fileName = fileURL.lastPathComponent
                
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
                    self.mainVM.path = actualPath
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
    @EnvironmentObject var mainVM: MainViewModel
    
    var body: some View {
        
        ScrollView(.horizontal) {
            HStack {
                ForEach( self.category.specs, id : \.id) { spec in
                    
                    Button {
                        self.mainVM.count = ""
                        self.mainVM.typeOfPrinting = ""
                        self.mainVM.selectedCategorySpec = nil
                        self.mainVM.additionalFunctionality = ""
                        
                        self.mainVM.size = spec.name
                        withAnimation{
                            self.mainVM.selectedCategorySpec = spec
                        }
                    } label: {
                        VStack {
                            
                            Image("dimens")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                                .foregroundColor( self.mainVM.size == spec.name ? Color.black : Color.gray)
                            
                            Text( spec.name )
                        }
                    }
                }
            }
        }
    }
}

struct ImportFile: View {
    
    @EnvironmentObject var mainVM: MainViewModel
    @Binding var openFile: Bool
    
    var body: some View {
        Button {
            self.openFile.toggle()
        } label: {
            
            HStack {
                Spacer()
                if self.mainVM.fileName == "" {
                    VStack {
                        Image("upload")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 150, height: 150)
                        
                        Text( "Ներբեռնել ֆայլը" )
                    }
                } else {
                    Text( self.mainVM.fileName )
                }
                Spacer()
            }
        }
    }
}

struct CalculatePriceButton: View {
    
    @EnvironmentObject var mainVM: MainViewModel
    let category: CategoryModel
    
    var body: some View {
        Button {
            self.mainVM.calculatePrice(category: self.category)
        } label: {
            
            Text( "Հաշվարկել Գումարը" )
                .foregroundColor(Color.white)
                .padding()
            
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .background(self.mainVM.buttonClickable ? Color.blue : Color.gray)
        .cornerRadius(10)
        .disabled(!self.mainVM.buttonClickable)
    }
}
