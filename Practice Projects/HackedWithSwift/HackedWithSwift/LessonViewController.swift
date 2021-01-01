//
//  LessonViewController.swift
//  HackedWithSwift
//
//  Created by Marcos Martinelli on 12/19/20.
//

// open target="_blank" links: https://nemecek.be/blog/1/how-to-open-target_blank-links-in-wkwebview-in-ios
// -- see line 32ß

import UIKit
import WebKit

class LessonViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    
    var webView: WKWebView!
    var progressView: UIProgressView!
    var urlString = ""
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        webView.uiDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // progress view
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        
        let progressBar = UIBarButtonItem(customView: progressView)
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)

        // toolbar
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        let backArrow = UIImage(systemName: "chevron.left")
        let rightArrow = UIImage(systemName: "chevron.right")
        let back = UIBarButtonItem(image: backArrow, style: .plain, target: webView, action: #selector(webView.goBack))
        let forward = UIBarButtonItem(image: rightArrow, style: .plain, target: webView, action: #selector(webView.goForward))
        
        toolbarItems = [back, spacer, forward, spacer, progressBar, spacer, spacer, refresh]
        navigationController?.isToolbarHidden = false
        
        webView.allowsBackForwardNavigationGestures = true
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if let frame = navigationAction.targetFrame, frame.isMainFrame {
            return nil
        }
        webView.load(navigationAction.request)
        return nil
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
}
