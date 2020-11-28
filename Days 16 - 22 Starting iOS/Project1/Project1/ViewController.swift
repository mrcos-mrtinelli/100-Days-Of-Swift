//
//  ViewController.swift
//  Project1
//
//  Created by Marcos Martinelli on 11/27/20.
//

import UIKit

class ViewController: UITableViewController {

    var pictures = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // read file
        let fm = FileManager.default
        let path = Bundle.main.resourcePath! // force unwrap because this path must exist, it's where the app lives
        let items = try! fm.contentsOfDirectory(atPath: path) // force unwrap again, resource must exist
        
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
            }
        }
        print(pictures)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Pictures", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        return cell
    }
}

