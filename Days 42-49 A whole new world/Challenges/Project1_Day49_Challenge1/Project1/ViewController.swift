//
//  ViewController.swift
//  Project1
//
//  Created by Marcos Martinelli on 11/27/20.
//

import UIKit

class ViewController: UITableViewController {

    var pictures = [String]()
    var viewCounts = [String: Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareApp))
        
        loadImages()
        loadDefaults()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    func loadImages() {
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
    func loadDefaults() {
        let defaults = UserDefaults.standard
        viewCounts = defaults.object(forKey: "viewCounts") as? [String: Int] ?? [String: Int]()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let imageName = pictures[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Pictures", for: indexPath)
        
        if let imageViewCount = viewCounts[imageName] {
            cell.detailTextLabel?.text = "\(imageViewCount) total views."
        } else {
            cell.detailTextLabel?.text = "No views."
        }
        
        cell.textLabel?.text = imageName
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            let image = pictures[indexPath.row]
            
            performSelector(inBackground: #selector(saveViews), with: image)
            
            vc.selectedImage = image
            vc.imageTitle = "Picture \(indexPath.row + 1) of \(pictures.count)"
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    @objc func saveViews(for image: String) {
        if viewCounts[image] != nil {
            viewCounts[image]! += 1
        } else {
            viewCounts[image] = 1
        }
        
        let defaults = UserDefaults.standard
        defaults.set(viewCounts, forKey: "viewCounts")
    }
    @objc func shareApp() {
        let shareAppDescription = "StormViewer is the best app ever!"
        let shareURL = URL(string: "https://www.apple.com/app-store/")
        
        let ac = UIActivityViewController(activityItems: [shareAppDescription, shareURL!], applicationActivities: [])
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
}

