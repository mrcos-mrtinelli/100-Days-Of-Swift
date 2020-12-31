//
//  ViewController.swift
//  Day50MilestoneProject
//
//  Created by Marcos Martinelli on 12/30/20.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var savedPictures = [Pictures]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(takePicture))
        
        loadSavedPictures()
        
        if savedPictures.isEmpty {
            print("we don't have any pictures")
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedPictures.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = savedPictures[indexPath.row].caption
    
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let picture = savedPictures[indexPath.row]
        if let vc = storyboard?.instantiateViewController(withIdentifier: "PictureVC") as? PictureViewController {
            let picturePath = getDocumentsDirectory().appendingPathComponent(picture.picture)
            vc.picturePath = picturePath.path
            vc.pictureTitle = picture.caption
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func loadSavedPictures() {
        let ud = UserDefaults.standard
        if let savedJSONData = ud.object(forKey: "savedPictures") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                savedPictures = try jsonDecoder.decode([Pictures].self, from: savedJSONData)
            } catch {
                print("oops, I don't know what happened.")
            }
        }
    }
    func savePictures() {
        let jsonEncoder = JSONEncoder()
        
        if let savingPictures = try? jsonEncoder.encode(savedPictures) {
            let ud = UserDefaults.standard
            ud.setValue(savingPictures, forKey: "savedPictures")
            let indexPath = IndexPath(row: savedPictures.count - 1, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
        } else {
            print("something went wrong")
        }
    }
    @objc func takePicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        }
        present(picker, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let picture = info[.editedImage] as? UIImage else { return }
        let pictureFileName = UUID().uuidString
        let picturePath = getDocumentsDirectory().appendingPathComponent(pictureFileName)
        
        if let jpegData = picture.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: picturePath)
        }
        
        let newPicture = Pictures(picture: pictureFileName, caption: "")
        
        dismiss(animated: true)
        
        getPictureCaption(picture: newPicture)
        
    }
    func getPictureCaption(picture: Pictures) {
        let ac = UIAlertController(title: "Caption", message: "Please add a caption or name to your picture", preferredStyle: .alert)
        
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] _ in
            guard let newCaption = ac?.textFields?[0].text else { return }
            picture.caption = newCaption
            self?.savedPictures.append(picture)
            self?.savePictures()
        })
        
        present(ac, animated: true)
    }
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

