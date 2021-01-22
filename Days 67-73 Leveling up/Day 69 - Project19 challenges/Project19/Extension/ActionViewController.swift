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
    var userScriptsForURL = [UserScripts]()
   
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
                    self?.pageURL = jsValues["URL"] as? String ?? ""
                    
                    DispatchQueue.main.async {
                        self?.title = "Script Editor"
                        self?.loadSavedScripts(urlString: self?.pageURL ?? "")
                    }
                }
            }
        }
    }
    func loadSavedScripts(urlString: String) {
        let defaults = UserDefaults.standard
        if let loadedData = defaults.object(forKey: "UserScripts") as? Data {
            let decoder = JSONDecoder()
            if let decodedData = try? decoder.decode([UserScripts].self, from: loadedData) {
                userScripts = decodedData
            }
        }
        
        guard let currentURL = URL(string: pageURL) else { return }
        userScriptsForURL = userScripts.filter({ script in
            script.url.host == currentURL.host
        })
        print("userScripptForURL count: \(userScriptsForURL.count)")
    }
    func saveToUserDefaults(url: URL, name: String, script: String) {
        let newScript = UserScripts(url: url, name: name, script: script)
        let encoder = JSONEncoder()
        
        userScripts.append(newScript)
        
        if let encoded = try? encoder.encode(userScripts) {
            let defaults = UserDefaults.standard
            defaults.setValue(encoded, forKey: "UserScripts")
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
        let saveScriptButton = UIAlertAction(title: "Save your script", style: .default, handler: saveScriptTapped)
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
    @objc func saveScriptTapped(action: UIAlertAction) {
        // case blank script
        guard script.text != "" else {
            let ac = UIAlertController(title: "Can't save blank script", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true)
            return
        }
        
        guard let scriptURL = URL(string: pageURL) else { return }
        guard let userScript = script.text else { return }
        var scriptName = ""
        
        let scriptNameAC = UIAlertController(title: "Enter Script Name", message: nil, preferredStyle: .alert)
        let submitAction = UIAlertAction(title: "Save", style: .default) { [weak self, weak scriptNameAC] _ in
            if var name = scriptNameAC?.textFields![0].text {
                
                if name == "" {
                    let today = Date()
                    let formatter = DateFormatter()
                    formatter.dateStyle = .short
                    
                    name = "Unnamed script (\(formatter.string(from: today)))"
                }
                
                scriptName = name
                self?.saveToUserDefaults(url: scriptURL, name: scriptName, script: userScript)
            }
        }
        
        scriptNameAC.addTextField(configurationHandler: nil)
        scriptNameAC.addAction(submitAction)
        scriptNameAC.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        present(scriptNameAC, animated: true)
    }
    @objc func loadScript(action: UIAlertAction) {
        if let vc = storyboard?.instantiateViewController(identifier: "TableView") as? LoadedScriptsViewController {
            vc.availableScripts = userScriptsForURL
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
extension ActionViewController: LoadedScriptDelegate {
    func loadSavedScript(_ loader: LoadedScriptsViewController, savedScript: String) {
        script.text = savedScript
    }
}
