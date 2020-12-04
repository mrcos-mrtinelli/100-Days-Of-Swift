//
//  FlagViewController.swift
//  FlagView
//
//  Created by Marcos Martinelli on 12/4/20.
//

import UIKit

class FlagViewController: UIViewController {
    
    @IBOutlet var flagImageView: UIImageView!
    
    var flagImage = String()
    var flagName = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareFlag))

        title = "Country: \(flagName)"
        flagImageView.image = UIImage(named: flagImage)
        
        flagImageView.layer.borderWidth = 1
        flagImageView.layer.borderColor = UIColor.lightGray.cgColor
        
    }
    @objc func shareFlag() {
        let image = UIImage(named: flagImage)?.jpegData(compressionQuality: 1)
        let ac = UIActivityViewController(activityItems: [image!, flagName], applicationActivities: [])
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        present(ac, animated: true)
    }
}
