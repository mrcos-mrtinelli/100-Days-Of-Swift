//
//  ActionViewController.swift
//  Extension
//
//  Created by Marcos Martinelli on 1/17/21.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {

    @IBOutlet var script: UITextView!
    
    var pageTitle = ""
    var pageURL = ""
    var userScripts = [UserScripts]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // CHALLENGE
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        let optionsButton = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(showOptions))
        
        navigationItem.leftBarButtonItem = doneButton
        navigationItem.rightBarButtonItem = optionsButton
        
        // add KVO to detect iphone keyboard changes
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    
        // extensionContext is an intermediary between Safari and our extension
        // get first item for inputItem from inputItems array, cast it as NDExtensionItem
        // this is what is being shared with our app
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            // inputItem is an NSExtension, get first item in .attachments array
            if let itemProvider = inputItem.attachments?.first {
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, error) in
                    guard let itemDict = dict as? NSDictionary else { return }
                    guard let jsValues = itemDict[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                    
                    self?.pageTitle = jsValues["title"] as? String ?? ""
                    self?.pageURL = jsValues["url"] as? String ?? ""
                    
                    DispatchQueue.main.async {
                        self?.title = "Script Editor"
                    }
                }
            }
        }
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            script.contentInset = .zero
        } else {
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        script.scrollIndicatorInsets = script.contentInset
        
        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
    }

    @IBAction func done() {
        let item = NSExtensionItem()
        let argument: NSDictionary = ["customJavaScript": script.text]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]
        
        extensionContext?.completeRequest(returningItems: [item])
    }
    @objc func showOptions() {
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let scriptSnippetsButton = UIAlertAction(title: "JS Script Examples", style: .default, handler: selectScriptSnippets)
        let saveScriptButton = UIAlertAction(title: "Save your script", style: .default, handler: saveScript)
        let loadScriptButton = UIAlertAction(title: "Load saved script", style: .default, handler: loadScript)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        ac.addAction(scriptSnippetsButton)
        ac.addAction(saveScriptButton)
        ac.addAction(loadScriptButton)
        ac.addAction(cancel)
        present(ac, animated: true)
    }
    @objc func selectScriptSnippets(action: UIAlertAction) {
        let ac = UIAlertController(title: "Select a script", message: nil, preferredStyle: .alert)
        
        let alertMessage = UIAlertAction(title: "Alert with custom message", style: .default) { [weak self] _ in
            self?.script.text = "alert(\"Enter your message between these quotes\");"
        }
        let changeBgColor = UIAlertAction(title: "Change background color", style: .default) { [weak self] _ in
            self?.script.text = "document.body.style.backgroundColor = \"red\";"
        }
        let changePageHeading = UIAlertAction(title: "Change page heading", style: .default) { [weak self] _ in
            self?.script.text = "document.getElementsByTagName(\"h1\")[0].innerHTML=\"Enter custom heading between these qoutes\";"
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        ac.addAction(alertMessage)
        ac.addAction(changeBgColor)
        ac.addAction(changePageHeading)
        ac.addAction(cancel)
        
        present(ac, animated: true)
    }
    @objc func saveScript(action: UIAlertAction) {
        guard script.text != "" else {
            let ac = UIAlertController(title: "Can't save blank script", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(ac, animated: true)
            return
        }
        let scriptURL = URL(string: pageURL)
        let scriptName = getScriptName()
        let scriptContent = """
        \(script.text!)
        """
        
        print(scriptURL?.absoluteString, scriptName, scriptContent)
        
    }
    @objc func loadScript(action: UIAlertAction) {
        
    }
    func getScriptName() -> String {
        var scriptName = ""
        let ac = UIAlertController(title: "Enter script's name", message: nil, preferredStyle: .alert)
        let submit = UIAlertAction(title: "Save", style: .default) { [weak ac] _ in
            if let name = ac?.textFields![0].text {
                scriptName = name
            } else {
                scriptName = ""
            }
        }
        
        ac.addTextField(configurationHandler: nil)
        ac.addAction(submit)
        present(ac, animated: true)
        
        return scriptName
    }
}
