//
//  DetailViewController.swift
//  Project1_Day43_Challenge
//
//  Created by Marcos Martinelli on 12/26/20.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var detailImageView: UIImageView!
    
    var imageName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let imageToLoad = imageName {
            detailImageView.image = UIImage(named: imageToLoad)
        }
    }

}
