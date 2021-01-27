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
        
        let spacer = UIBarButtonItem(systemItem: .flexibleSpace)
        let newNoteIcon = UIImage(systemName: "square.and.pencil")
        let newNote = UIBarButtonItem(image: newNoteIcon, style: .plain, target: self, action: #selector(addNoteTapped))
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.isToolbarHidden = false
        toolbarItems = [spacer, newNote]
        
        title = folder.name

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folder.notes.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        let note = folder.notes[indexPath.row]
        let noteComponents = note.body.components(separatedBy: "\n")
        
        if noteComponents.count > 1 {
            cell.textLabel?.text = noteComponents.first
            cell.detailTextLabel?.text = noteComponents[1]
        } else {
            cell.textLabel?.text = noteComponents.first
            cell.detailTextLabel?.text = "No additional text"
        }

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let noteDetail = storyboard?.instantiateViewController(identifier: "NoteDetail") as? NoteDetailViewController {
            noteDetail.body = folder.notes[indexPath.row].body
            noteDetail.folderID = folder.id
            
            navigationController?.pushViewController(noteDetail, animated: true)
        }
    }
    @objc func addNoteTapped() {
    }
}

