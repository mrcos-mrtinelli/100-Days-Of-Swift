//
//  FolderDetailTableViewController.swift
//  Milestone-Projects19-21
//
//  Created by Marcos Martinelli on 1/24/21.
//

import UIKit

class FolderDetailTableViewController: UITableViewController {
    var notesManager = NotesManager()
    var folder: Folder!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = folder.name
        // Uncomment the following line to preserve selection between presentations
//         self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//         self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folder.notes.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        let note = folder.notes[indexPath.row]
        cell.textLabel?.text = note.body

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let noteDetail = storyboard?.instantiateViewController(identifier: "NoteDetail") as? NoteDetailViewController {
            noteDetail.body = folder.notes[indexPath.row].body
            
            navigationController?.pushViewController(noteDetail, animated: true)
        }
    }

}
