//
//  ViewController.swift
//  Project4
//
//  Created by Marcos Martinelli on 12/2/20.
//

import UIKit
import WebKit

class WVViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var progressView: UIProgressView! // create a progress view
    var safeWebsites = [String]()
    var selectedWebsite: String?
    
    // create the view that the controller manages
    override func loadView() {
        // create an instance of WKWebView and store in webView
        webView = WKWebView()
        // modify webView's navigationDelegate
        webView.navigationDelegate = self
        // make is the view for our controller
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sites", style: .plain, target: self, action: #selector(openTapped))
        
        // https://stackoverflow.com/questions/21418317/buttons-on-the-safari-browser-toolbar
        let backArrow = UIImage(systemName: "chevron.left")
        let rightArrow = UIImage(systemName: "chevron.right")
        // create the components for the toolBar
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let back = UIBarButtonItem(image: backArrow, style: .plain, target: webView, action: #selector(webView.goBack))
        let forward = UIBarButtonItem(image: rightArrow, style: .plain, target: webView, action: #selector(webView.goForward))
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        
        // create the progress view
        progressView = UIProgressView(progressViewStyle: .default)
        // the progressView's size
        progressView.sizeToFit()
        // create progressview as a UIBarButtonItem so it's usable in the toolBar
        let progressButton = UIBarButtonItem(customView: progressView)
        
        // set View Controllers toolBar property
        toolbarItems = [back, spacer, forward, spacer, progressButton, spacer, spacer, refresh]
        navigationController?.isToolbarHidden = false
        
        // KVO - add an observer to WKWebView
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        let url = URL(string: "https://" + selectedWebsite!)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    func openPage(action: UIAlertAction) {
        guard let actionTitle = action.title else { return }
        guard let url = URL(string: "https://" + actionTitle) else { return }
        // let url = URL(string: "https://" + action.title!)! // double unwrap becuase we made sure the url is good
        webView.load(URLRequest(url: url))
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        let url = navigationAction.request.url
        guard let stringURL = url?.absoluteString else { return }
            
        if let host = url?.host {
            for website in safeWebsites {
                if host.contains(website) {
                    decisionHandler(.allow)
                    return
                }
            }
        }
        decisionHandler(.cancel)
        showWarning(alertTitle: "Invalid Website", alertMessage: "\(stringURL) is not a safe website to visit.", alertAction: "Dismiss")
    }
    func showWarning(alertTitle: String, alertMessage: String, alertAction: String) {
        let ac = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: alertAction, style: .default, handler: nil))
        present(ac, animated: true)
    }
}

