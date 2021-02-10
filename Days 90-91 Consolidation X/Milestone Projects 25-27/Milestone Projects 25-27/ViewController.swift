//
//  ViewController.swift
//  Milestone Projects 25-27
//
//  Created by Marcos Martinelli on 2/9/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    
    var newImage: UIImage!
    

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
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let picker = UIImagePickerController()
            
            picker.delegate = self
            picker.allowsEditing = true
            
            popoverPresentationController?.barButtonItem = toolbarItems![0]
            present(picker, animated: true)
            
        } else {
            print("No access to photoLibrary")
            
        }
    }
    func textRenderer() {
        let imgWidth: CGFloat = newImage.size.width
        let imgHeight: CGFloat = newImage.size.height
        let renderer = UIGraphicsImageRenderer(
            size: CGSize(
                width: imgWidth,
                height: imgHeight
            )
        )
        let overlay = renderer.image { (context) in
            let overlayArea = CGRect(x: 0, y: 0, width: imgWidth, height: imgHeight)
            
            let paragraphStyle = NSMutableParagraphStyle()
            
            paragraphStyle.alignment = .center
            
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 72, weight: .bold),
                .paragraphStyle: paragraphStyle
            ]
            let string = "This is a test."
            let attributedString = NSAttributedString(string: string, attributes: attributes)
            
            attributedString.draw(
                with: CGRect(x: 0, y: 0, width: imgWidth, height: 100),
                options: .usesLineFragmentOrigin,
                context: nil
            )
            
            newImage.draw(in: overlayArea, blendMode: .overlay, alpha: 1)
        }
        
        imageView.image = overlay
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.editedImage] as? UIImage else {
            
            print("no image found")
            
            return
        }
        
        newImage = selectedImage
//        imageView.image = selectedImage
        textRenderer()
        
        dismiss(animated: true)
    }
}

