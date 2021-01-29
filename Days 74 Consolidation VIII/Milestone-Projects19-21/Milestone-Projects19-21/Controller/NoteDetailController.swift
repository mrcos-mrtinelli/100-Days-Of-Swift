//
//  NoteDetailViewController.swift
//  Milestone-Projects19-21
//
//  Created by Marcos Martinelli on 1/24/21.
//

import UIKit

protocol NoteDetailControllerDelegate {
    func didCreateNote(_ note: String?)
    func didUpdateNote(_ note: String)
}
extension NoteDetailControllerDelegate {
    func didCreateNote(_ note: String?) {}
    func didUpdateNote(_ note: String) {}
}

class NoteDetailController: UIViewController {
    @IBOutlet var textView: UITextView!
    
    var isNewNote: Bool!
    var body: String!
    
    var delegate:NoteDetailControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        
        textView.text = body
    }
    // when user hits "< Back" on navigationController
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        // if self is being popped out of navigation stack
        if self.isMovingFromParent {
            if isNewNote {
                delegate?.didCreateNote(textView.text)
            } else {
                delegate?.didUpdateNote(textView.text)
            }
        }
    }
}



