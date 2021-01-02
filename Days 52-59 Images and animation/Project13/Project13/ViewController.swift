//
//  ViewController.swift
//  Project13
//
//  Created by Marcos Martinelli on 1/2/21.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var intensity: UISlider!
    // store image user selected
    var currentImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "YACIFP"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
    }
    
    @IBAction func intensityChanged(_ sender: Any) {
    }
    @IBAction func changeFilter(_ sender: Any) {
    }
    @IBAction func savePressed(_ sender: Any) {
    }
    
    // image picker code
    @objc func importPicture() {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    // UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        currentImage = image
        dismiss(animated: true)
    }
}

