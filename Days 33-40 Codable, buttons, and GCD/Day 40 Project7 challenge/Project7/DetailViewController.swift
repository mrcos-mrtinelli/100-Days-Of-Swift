//
//  DetailViewController.swift
//  Project7
//
//  Created by Marcos Martinelli on 12/15/20.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    
    var webView: WKWebView!
    var detailItem: Petition?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let detailItem = detailItem else { return }
        
        let html = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style>
            body { font-size: 120%; font-family: Arial; color: #5a5a5a; }
            h2 { margin-top: 1.5rem; margin-bottom: 2rem; color: #414141; }
        </style>
        </head>
        <body>
        <h2>\(detailItem.title)</h2>
        \(detailItem.body)
        </body>
        </html>
        """
        
        webView.loadHTMLString(html, baseURL: nil)
    }
}
