//
//  NoteDetailViewController.swift
//  Milestone-Projects19-21
//
//  Created by Marcos Martinelli on 1/24/21.
//

import UIKit

protocol NoteDetailControllerDelegate {
    func didFinishNote(_ note: String?)
}

class NoteDetailController: UIViewController {
    @IBOutlet var textView: UITextView!
    
    var folderID: String!
    var body: String!
    
    var delegate:NoteDetailControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        
        // add padding https://www.hackingwithswift.com/example-code/uikit/how-to-pad-a-uitextview-by-setting-its-text-container-inset
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 20)
        textView.text = body
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        if self.isMovingFromParent {
            delegate?.didFinishNote(textView.text)
        }
    }
}



