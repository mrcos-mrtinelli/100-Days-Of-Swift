//
//  FolderDetailTableViewController.swift
//  Milestone-Projects19-21
//
//  Created by Marcos Martinelli on 1/24/21.
//

import UIKit

class FolderDetailController: UITableViewController {
    var notesManager: NotesManager!
    var folder: Folder!
    var currentFolderID: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let spacer = UIBarButtonItem(systemItem: .flexibleSpace)
        let newNoteIcon = UIImage(systemName: "square.and.pencil")
        let newNote = UIBarButtonItem(image: newNoteIcon, style: .plain, target: self, action: #selector(createNewNote))
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.isToolbarHidden = false
        toolbarItems = [spacer, newNote]
        
        tableView.tableFooterView = UIView()
        
        title = folder.name
        notesManager = NotesManager()
        notesManager.delegate = self
    }
    @objc func createNewNote() {
        if let noteVC = storyboard?.instantiateViewController(withIdentifier: "NoteDetail") as? NoteDetailController {
            noteVC.delegate = self
            navigationController?.pushViewController(noteVC, animated: true)
        }
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
        if let noteDetail = storyboard?.instantiateViewController(identifier: "NoteDetail") as? NoteDetailController {
            noteDetail.delegate = self
            noteDetail.noteID = folder.notes[indexPath.row].id
            noteDetail.body = folder.notes[indexPath.row].body
            
            navigationController?.pushViewController(noteDetail, animated: true)
        }
    }
}

//MARK: - NoteDetailControllerDelegate
extension FolderDetailController: NoteDetailControllerDelegate {
    func didCreateNote(_ note: String?) {
        guard let body = note, note != "" else { return }
        notesManager.createNew(note: body, noteID: nil, folderID: currentFolderID)
    }
    func didUpdateNote(_ note: String, noteID: String) {
        notesManager.update(note: note, noteID: noteID, folderID: currentFolderID)
    }
}
//MARK: - NotesManagerDelegate
extension FolderDetailController: NotesManagerDelegate {
    func didSave(note: Note, to folders: [Folder]) {
        let index = notesManager.getFolderIndex(for: currentFolderID, in: folders)
        folder = folders[index]
        tableView.reloadData()
    }
    
    
}
