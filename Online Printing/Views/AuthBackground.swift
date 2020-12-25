//
//  AuthBackground.swift
//  Online Printing
//
//  Created by Karen Mirakyan on 10.12.20.
//

import SwiftUI

struct AuthBackground: View {
    var body: some View {
        Image( "background" )
             .resizable()
             .edgesIgnoringSafeArea(.all)
    }
}

struct AuthBackground_Previews: PreviewProvider {
    static var previews: some View {
        AuthBackground()
    }
}
