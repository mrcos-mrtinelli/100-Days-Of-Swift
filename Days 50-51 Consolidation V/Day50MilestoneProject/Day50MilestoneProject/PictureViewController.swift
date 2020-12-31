//
//  PictureViewController.swift
//  Day50MilestoneProject
//
//  Created by Marcos Martinelli on 12/31/20.
//

import UIKit

class PictureViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    var picturePath: String?
    var pictureTitle: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = pictureTitle
        
        if let picture = picturePath {
            imageView.image = UIImage(contentsOfFile: picture)
        }
    }
}
