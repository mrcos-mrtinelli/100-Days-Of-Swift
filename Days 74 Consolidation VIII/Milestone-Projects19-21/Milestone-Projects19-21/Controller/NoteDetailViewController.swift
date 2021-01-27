//
//  NoteDetailViewController.swift
//  Milestone-Projects19-21
//
//  Created by Marcos Martinelli on 1/24/21.
//

import UIKit

class NoteDetailViewController: UIViewController {
    @IBOutlet var textView: UITextView!
    
    var body: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        // add padding https://www.hackingwithswift.com/example-code/uikit/how-to-pad-a-uitextview-by-setting-its-text-container-inset
        textView.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        textView.text = body
        
    }
}
