//
//  WebView.swift
//  Online Printing
//
//  Created by Karen Mirakyan on 06.01.21.
//

import Foundation
import SwiftUI
import UIKit
import WebKit

struct WebView: UIViewRepresentable {
    
    var url: String
    @EnvironmentObject var mainVM: MainViewModel
    @Environment(\.presentationMode) var presentationMode

    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        guard let url = URL(string: self.url ) else {
            return WKWebView()
        }
        
        print(url)
        
        let request = URLRequest(url: url)
        let wkWebview = WKWebView()
        wkWebview.uiDelegate = context.coordinator
        wkWebview.navigationDelegate = context.coordinator
        wkWebview.load(request)
        return wkWebview
    }
    
    func updateUIView(_ uiView: WKWebView , context: Context) {
        
    }
    
    final class Coordinator: NSObject, WKUIDelegate, WKNavigationDelegate {
        var webView: WebView
        
        init(_ webView: WebView) {
            self.webView = webView
        }
        
        func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
            completionHandler( true )
        }
        
        func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
            completionHandler()
        }
        
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
            
            print(webView.url?.absoluteString)
            
            if webView.url?.absoluteString.contains("/ArcaResponse") == true {
                decisionHandler( .cancel )
                self.webView.mainVM.showWeb = false
                self.webView.mainVM.getResponse()
                self.webView.presentationMode.wrappedValue.dismiss()

            } else {
                decisionHandler( .allow )
            }
        }
        
        func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
            completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
        }
    }
}
