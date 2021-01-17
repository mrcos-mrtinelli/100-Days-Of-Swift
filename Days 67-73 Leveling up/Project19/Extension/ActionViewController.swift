//
//  ActionViewController.swift
//  Extension
//
//  Created by Marcos Martinelli on 1/17/21.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
    
        // extensionContext is an intermediary between Safari and our extension
        // get first item for inputItem from inputItems array, cast it as NDExtensionItem
        // this is what is being shared with our app
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            // inputItem is an NSExtension, get first item in .attachments array
            if let itemProvider = inputItem.attachments?.first {
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, error) in
                    // data has been loaded, code below manipulates the data
                }
            }
        }
    }

    @IBAction func done() {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
    }

}
