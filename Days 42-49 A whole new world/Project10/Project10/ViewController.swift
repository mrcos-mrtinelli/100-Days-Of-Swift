//
//  ViewController.swift
//  Project10
//
//  Created by Marcos Martinelli on 12/23/20.
//

// if cells are not showig the labels or correct size:
// https://www.hackingwithswift.com/forums/100-days-of-swift/project-10-basic-layout-failing/1759/1761

import UIKit

class ViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("Unable to dequeue PersonCell")
        }
        return cell
    }
}

