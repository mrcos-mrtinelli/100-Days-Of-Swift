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
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // challege #2 from technique project #3 - add a share button that shares this app
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareApp))
        
        performSelector(inBackground: #selector(getFiles), with: nil)
       
    }
    
    @objc func getFiles() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath! // force unwrap because this path must exist, it's where the app lives
        let items = try! fm.contentsOfDirectory(atPath: path) // force unwrap again, resource must exist
        
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
            }
        }
        pictures.sort()
        
        tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Pictures", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row]
            // challenge
            vc.imageTitle = "Picture \(indexPath.row + 1) of \(pictures.count)"
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    @objc func shareApp() {
        let shareAppDescription = "StormViewer is the best app ever!"
        let shareURL = URL(string: "https://www.apple.com/app-store/")
        // for unwrapping URL because I know it'll be there
        let ac = UIActivityViewController(activityItems: [shareAppDescription, shareURL!], applicationActivities: [])
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
}

