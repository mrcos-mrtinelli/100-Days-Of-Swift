//
//  ViewController.swift
//  Project1_Day43_Challenge
//
//  Created by Marcos Martinelli on 12/26/20.
//

import UIKit

class ViewController: UICollectionViewController {
    
    var pictures = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "StormViewer 2.0"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
            }
        }
        pictures.sort()
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Picture", for: indexPath) as? PictureCell else {
            fatalError("Unable to find PictureCell")
        }
        cell.imageView.image = UIImage(named: pictures[indexPath.item])
        cell.name.text = pictures[indexPath.item]
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "DetailView") as? DetailViewController {
            vc.imageName = pictures[indexPath.item]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

