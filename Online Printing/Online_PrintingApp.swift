//
//  Online_PrintingApp.swift
//  Online Printing
//
//  Created by Karen Mirakyan on 26.09.20.
//

import SwiftUI
import IdramMerchantPayment

@main
struct Online_PrintingApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        let newAppearance = UINavigationBarAppearance()
        newAppearance.configureWithOpaqueBackground()
        newAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black, .font: UIFont( name: "McLaren-Regular", size: 20)!]
        
        UINavigationBar.appearance().standardAppearance = newAppearance
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL(perform: { (url) in
                    if let urlComponents = URLComponents(string: url.absoluteString), let host = urlComponents.host, let queryItems = urlComponents.queryItems {

                        print(host) // mydummysite.com

                        print(queryItems) // [encodedMessage=PD94bWwgdmVyNlPg==, signature=kcig33sdAOAr/YYGf5r4HGN]
                        for item in queryItems {
                            print("\(item.name) -> \(item.value)")
                        }
                    }
//                    print( "Karen Mirakyan opened this url -> \(url)" )
                })
        }
    }
}
