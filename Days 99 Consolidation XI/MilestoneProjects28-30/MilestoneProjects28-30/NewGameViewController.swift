//
//  ViewController.swift
//  MilestoneProjects28-30
//
//  Created by Marcos Martinelli on 2/18/21.
//

import UIKit

class NewGameViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Card", for: indexPath)
        
        let random = Int.random(in: 0...2)
        var color: UIColor
        
        switch random {
        case 0:
            color = .black
        case 1:
            color = .yellow
        case 2:
            color = .green
        default:
            color = .blue
        }
        
        cell.backgroundColor = color
        
        return cell
    }
}

