//
//  Online_PrintingApp.swift
//  Online Printing
//
//  Created by Karen Mirakyan on 26.09.20.
//

import SwiftUI

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
        }
    }
}
