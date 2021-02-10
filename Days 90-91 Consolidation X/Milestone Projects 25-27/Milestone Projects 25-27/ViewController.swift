//
//  ViewController.swift
//  Milestone Projects 25-27
//
//  Created by Marcos Martinelli on 2/9/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Meme Generator"
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let importPictureBtn = UIBarButtonItem(title: "Import Picture", style: .plain, target: self, action: #selector(importPictureTapped))
        let setTopTextBtn = UIBarButtonItem(title: "Top Text", style: .plain, target: self, action: #selector(importPictureTapped))
        let setBottomTextBtn = UIBarButtonItem(title: "Bottom Text", style: .plain, target: self, action: #selector(importPictureTapped))
        
        toolbarItems = [importPictureBtn, spacer, setTopTextBtn, spacer, setBottomTextBtn]
        navigationController?.isToolbarHidden = false
    }
    @objc func importPictureTapped() {
        
    }
}

