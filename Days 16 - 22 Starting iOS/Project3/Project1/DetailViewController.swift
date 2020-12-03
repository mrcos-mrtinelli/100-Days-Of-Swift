//
//  DetailViewController.swift
//  Project1
//
//  Created by Marcos Martinelli on 11/28/20.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    
    var selectedImage: String?
    var imageTitle: String? 


    override func viewDidLoad() {
        super.viewDidLoad()
        // challenge
        title = imageTitle
        navigationItem.largeTitleDisplayMode = .never
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))

        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }

    @objc func shareTapped() {
        guard let imageName = imageTitle else { return }
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
            print("No image to share.")
            return
        }
        
        // challenge #1 - add the image name to the list of items being shared
        let ac = UIActivityViewController(activityItems: [image, imageName], applicationActivities: [])
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }

}
