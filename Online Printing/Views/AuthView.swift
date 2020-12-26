//
//  AuthView.swift
//  Online Printing
//
//  Created by Karen Mirakyan on 10.12.20.
//

import SwiftUI
import AlertX

struct AuthView: View {
    
    @EnvironmentObject var authVM: AuthViewModel
    
    var body: some View {
        if self.authVM.showLoading {
            Loading()
        } else {
            ZStack {
                AuthBackground()
                
                VStack( spacing: 20) {
                    
                    Image( "authPageLogo" )
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.size.width/1.5, height: UIScreen.main.bounds.size.height/3.5)
                        .cornerRadius(30)
                    
                    Text( "OnlinePrinting.am" )
                        .font(.system(size: 25))
                        .foregroundColor(Color.white)

                    NumberInput().environmentObject(self.authVM)
                    
                    VStack {
                        
                        TextField( "Հաստատման կոդ", text: self.$authVM.confirmationCode)
                            .padding([.top, .bottom], 14)
                            .keyboardType(.numberPad)
                            .foregroundColor(Color.white)
                            .font(.system(size: 16))
                            .multilineTextAlignment(.center)
                        
                    }.padding([.leading, .trailing], 12)
                    .background(
                        Image("signUpTextFieldBg")
                            .resizable()
                            .aspectRatio(contentMode: .fill))
                    .cornerRadius(8)
                    
                    VStack {
                        Text( "Գրանցվել")
                            .foregroundColor(Color.white)
                            .font(.system(size: 20))
                        
                    }.padding([.top, .bottom], 11)
                    .frame(width: UIScreen.main.bounds.size.width-30)
                    .background(
                        Image("signUpButtonBackground")
                            .resizable()
                            .aspectRatio(contentMode: .fill))
                    .cornerRadius(20)
                    .onTapGesture {
                        if self.authVM.number != "" && self.authVM.confirmationCode != "" {
                            self.authVM.logTheUser()
                        } else {
                            self.authVM.showAlert = true
                        }
                    }
                    
                    
                    Text( "Ձեր ընտրությունը" )
                        .foregroundColor(Color.white)
                        .font(.system(size: 14))
                        .padding()
                    
                    Text( "Մեր հոգսն է" )
                        .foregroundColor(Color.white)
                        .font(.system(size: 20))
                        .padding(6)
                    
                }.padding()
                .animation(.spring())
            }.alert(isPresented: self.$authVM.showAlert, content: {
                Alert(title: Text( "Սխալ" ), message: Text( "Մուտքագրեք հեռախոսահամարը և հաստատման կոդը" ), dismissButton: .default(Text( "Լավ" )))
            })
        }
    }
    
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}

struct NumberInput: View {
    
    @EnvironmentObject var authVM: AuthViewModel
    
    var body: some View {
        HStack{
            Text( "+374" )
                .font(.system(size: 35))
                .foregroundColor(Color.white)
            
            Image( "cursor" )
                .resizable()
                .frame(width: 2, height: 35)
            
            TextField("", text: self.$authVM.number)
                .keyboardType(.numberPad)
                .foregroundColor(Color.white)
                .font(.system(size: 35))
                .frame( height: 35)
            
            Image( "signUpNumberAttr" )
                .resizable()
                .renderingMode(.template)
                .frame(width: 35, height: 35)
                .foregroundColor(self.authVM.number.count == 8 ? Color.white : Color.gray)
                // send verification code
                .onTapGesture {
                    self.authVM.signUp()
                }
            
            Spacer()
        }.padding([.leading, .trailing], 12)
        .padding([.top, .bottom], 5)
        .background(
            Image("signUpTextFieldBg")
                .resizable()
                .aspectRatio(contentMode: .fill)
        ).cornerRadius(8)
    }
}
