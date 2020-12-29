//
//  ViewController.swift
//  Project10
//
//  Created by Marcos Martinelli on 12/23/20.
//

// if cells are not showig the labels or correct size:
// https://www.hackingwithswift.com/forums/100-days-of-swift/project-10-basic-layout-failing/1759/1761

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var people = [Person]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userDefaults = UserDefaults.standard
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
        
        if let codedPeople = userDefaults.object(forKey: "people") as? Data {
            if let decodedPeople = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(codedPeople) as? [Person] {
                people = decodedPeople
            }
        }
        
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("Unable to dequeue PersonCell")
        }
        
        let person = people[indexPath.item]
        let imagePath = getDocumentsDirectory().appendingPathComponent(person.image)
        
        cell.name.text = person.name
        cell.imageView.image = UIImage(contentsOfFile: imagePath.path)
        
        cell.imageView.layer.borderWidth = 1
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        let ac = UIAlertController(title: "\(person.name)", message: "Would you like to rename or delete this person?", preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Rename", style: .default) {
            [weak self] _ in
            self?.renamePerson(person: person)
        })
        ac.addAction(UIAlertAction(title: "Delete", style: .default) {
            [weak self] _ in
            self?.deletePerson(person: person)
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .default))
        
        present(ac, animated: true)
    }
    func renamePerson(person: Person) {
        let ac = UIAlertController(title: "Rename Person", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Rename", style: .default) {
            [weak self, weak ac] _ in
            guard let newName = ac?.textFields?[0].text else { return }
            person.name = newName
            self?.saveAndReload()
        })
        present(ac, animated: true)
    }
    func deletePerson(person: Person) {
        guard let index = people.firstIndex(of: person) else { return }
        let fm = FileManager.default
        let imagePath = getDocumentsDirectory().appendingPathComponent(person.image)
        
        try? fm.removeItem(at: imagePath)

        people.remove(at: index)
        saveAndReload()
    }
    
    @objc func addNewPerson() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        }
        
        present(picker, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let person = Person(name: "Unknown", image: imageName)
        
        people.append(person)
        saveAndReload()
        dismiss(animated: true)
    }
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    func saveAndReload() {
        if let saveData = try? NSKeyedArchiver.archivedData(withRootObject: people, requiringSecureCoding: false) {
            let userDefaults = UserDefaults.standard
            
            userDefaults.setValue(saveData, forKey: "people")
            collectionView.reloadData()
        }
    }
}

