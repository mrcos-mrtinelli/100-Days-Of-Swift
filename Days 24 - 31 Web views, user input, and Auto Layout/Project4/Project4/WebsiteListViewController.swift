//
//  WebSitesViewController.swift
//  Project4
//
//  Created by Marcos Martinelli on 12/5/20.
//

import UIKit

class WebsiteListViewController: UITableViewController {
    
    var webSites = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Please select a site"
        
        webSites += ["apple.com", "hackingwithswift.com", "developer.apple.com"]
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return webSites.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Site")
        cell.textLabel?.text = webSites[indexPath.row]
        // disclosuer indicator not respecting the details options ¯\_(ツ)_/¯
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let vc = storyboard?.instantiateViewController(identifier: "WebView") as? WVViewController {
            vc.safeWebsites += webSites
            vc.selectedWebsite = webSites[indexPath.row]
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
