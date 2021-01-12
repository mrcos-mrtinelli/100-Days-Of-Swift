//
//  WebViewViewController.swift
//  Project16
//
//  Created by Marcos Martinelli on 1/11/21.
//

import UIKit
import WebKit

class WebViewViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var wikipediaURL: String!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = URL(string: wikipediaURL)  {
            webView.load(URLRequest(url: url))
        }
    }

}
