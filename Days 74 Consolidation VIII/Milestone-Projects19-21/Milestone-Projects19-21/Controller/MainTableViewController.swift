//
//  ViewController.swift
//  Milestone-Projects19-21
//
//  Created by Marcos Martinelli on 1/24/21.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    var notesManager = NotesManager()
    var allNotes = [Folder]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.setToolbarHidden(false, animated: false)
        title = "Notes"
        
        notesManager.delegate = self
        notesManager.load()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allNotes.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FolderCell", for: indexPath)
        
        if let folderCell = cell as? FolderCell {
            folderCell.folderName.text = allNotes[indexPath.row].name
            folderCell.notesCount.text = "\(allNotes[indexPath.row].notes.count)"
            return folderCell
        }
        
        return cell
    }
}

//MARK: NotesManagerDelegate
extension MainTableViewController: NotesManagerDelegate {
    func didLoadNotes(_ notesManager: NotesManager, notes: [Folder]) {
        allNotes = notes
        tableView.reloadData()
    }
}

