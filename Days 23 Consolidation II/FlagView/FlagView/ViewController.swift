//
//  ViewController.swift
//  FlagView
//
//  Created by Marcos Martinelli on 12/4/20.
//

import UIKit

class ViewController: UITableViewController {

    var flagImages = [String]()
    var flagNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Flag View"
        
        // Load images into flagImages property
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.contains(".png") {
                let flagName = item.dropLast(4)
                flagNames.append(String(flagName))
                flagImages.append(item)
                
            }
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flagImages.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Flag", for: indexPath)
        cell.imageView?.image = UIImage(named: flagImages[indexPath.row])
        cell.textLabel?.text = flagNames[indexPath.row]
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "FlagViewController") as? FlagViewController {
            vc.flagName = flagNames[indexPath.row]
            vc.flagImage = flagImages[indexPath.row]
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

