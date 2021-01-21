//
//  TableViewController.swift
//  Extension
//
//  Created by Marcos Martinelli on 1/20/21.
//

protocol LoadedScriptsViewControllerDelegate {
    func insertScript(insertScript: String)
}

import UIKit

class LoadedScriptsViewController: UITableViewController {
    
    var delegate: LoadedScriptsViewControllerDelegate?
    
    var availableScripts = [UserScripts]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availableScripts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Script", for: indexPath)
        cell.textLabel?.text = availableScripts[indexPath.row].name
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let script = availableScripts[indexPath.row].script
        
        DispatchQueue.main.async {
            self.delegate?.insertScript(insertScript: script)
        }
        
        navigationController?.popViewController(animated: true)
    }

}
