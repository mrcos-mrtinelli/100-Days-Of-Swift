//
//  TableViewController.swift
//  Extension
//
//  Created by Marcos Martinelli on 1/20/21.
//

import UIKit

protocol LoadedScriptDelegate {
    func loadSavedScript(_ loader: LoadedScriptsViewController, savedScript: String)
}

class LoadedScriptsViewController: UITableViewController {
    
    var delegate: LoadedScriptDelegate?
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
        
        delegate?.loadSavedScript(self, savedScript: script)
        navigationController?.popViewController(animated: true)
    }

}
