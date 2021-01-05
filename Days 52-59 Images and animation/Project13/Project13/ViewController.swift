//
//  ViewController.swift
//  Project13
//
//  Created by Marcos Martinelli on 1/2/21.
//
import CoreImage
import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var intensity: UISlider!
    @IBOutlet var radius: UISlider!
    
    @IBOutlet var changeFilterButton: UIButton!
    
    // store image user selected
    var currentImage: UIImage!
    
    // core image
    var context: CIContext!
    var currentFilter: CIFilter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "YACIFP"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
        
        // core image
        context = CIContext()
        currentFilter = CIFilter(name: "CISepiaTone")
    }
    
    @IBAction func intensityChanged(_ sender: Any) {
        if currentImage == nil {
            print("no image")
        }
        applyProcessing()
    }
    @IBAction func radiusChanged(_ sender: Any) {
        if currentImage == nil {
            print("no image")
        }
        applyProcessing()
    }
    
    @IBAction func changeFilter(_ sender: UIButton) {
        let ac = UIAlertController(title: "Choose Filter", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Bump Distortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "Gaussian Blur", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "Pixellate", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "Sepia Tone", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "Twirl Distortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "Unsharp Mask", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "Vignette", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        if let popoverController = ac.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
        
        present(ac, animated: true)
        
    }
    @IBAction func savePressed(_ sender: Any) {
        guard let image = imageView.image else {
            let ac = UIAlertController(title: "Error: No image to save.", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            
            return
        }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Error saving", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Image Saved", message: "Your image saved successfully!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            present(ac, animated: true)
        }
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
        
        // core image
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
    func setFilter(action: UIAlertAction) {
        guard currentImage != nil else { return }
        guard let actionTitle = action.title else { return }
        
        changeFilterButton.setTitle("Filter: \(actionTitle)", for: .normal)
        currentFilter = CIFilter(name: getFilterReference(title: actionTitle))

        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        applyProcessing()
    }
    func getFilterReference(title: String) -> String {
        switch title {
        case "Bump Distortion":
            return "CIBumpDistortion"
        case "Gaussian Blur":
            return "CIGaussianBlur"
        case "Pixellate":
            return "CIPixellate"
        case "Sepia Tone":
            return "CISepiaTone"
        case "Twirl Distortion":
            return "CITwirlDistortion"
        case "Unsharp Mask":
            return "CIUnsharpMask"
        case "Vignette":
            return "CIVignette"
        default:
            return "ERROR"
        }
    }
        
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        
        for key in inputKeys {
            print(key)
        }
        
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey)
        }
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(radius.value * 200, forKey: kCIInputRadiusKey)
        }
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(intensity.value * 10, forKey: kCIInputScaleKey)
        }
        if inputKeys.contains(kCIInputCenterKey) {
            currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey)
        }
        
        guard let outputImage = currentFilter.outputImage else { return }
        
        // cannot use processed imaged in UIImage
        // must run it through CGImage, then run it in UIImage
        if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            let processedImage = UIImage(cgImage: cgImage)
            imageView.image = processedImage
        }
    }
}

