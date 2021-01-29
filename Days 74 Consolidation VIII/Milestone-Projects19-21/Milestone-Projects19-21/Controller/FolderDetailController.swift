//
//  FolderDetailTableViewController.swift
//  Milestone-Projects19-21
//
//  Created by Marcos Martinelli on 1/24/21.
//

import UIKit

class FolderDetailController: UITableViewController {
    
    var notesManager = NotesManager()
    var currentFolderID: String!
    var folder: Folder!
    var selectedNoteID: String!
    var isNewNote: Bool!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let spacer = UIBarButtonItem(systemItem: .flexibleSpace)
        let newNoteIcon = UIImage(systemName: "square.and.pencil")
        let newNote = UIBarButtonItem(image: newNoteIcon, style: .plain, target: self, action: #selector(createNewNote))
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.isToolbarHidden = false
        
        toolbarItems = [spacer, newNote]
        title = folder.name
        
        tableView.tableFooterView = UIView()
        
        notesManager.delegate = self
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
        if let noteDetailVC = storyboard?.instantiateViewController(identifier: "NoteDetail") as? NoteDetailController {
            selectedNoteID = folder.notes[indexPath.row].id
            isNewNote = false
            
            noteDetailVC.delegate = self
            noteDetailVC.body = folder.notes[indexPath.row].body
            
            navigationController?.pushViewController(noteDetailVC, animated: true)
        }
    }
    //MARK: - toolbar functions
    @objc func createNewNote() {
        if let noteDetailVC = storyboard?.instantiateViewController(withIdentifier: "NoteDetail") as? NoteDetailController {
            isNewNote = true
            
            noteDetailVC.delegate = self
            
            navigationController?.pushViewController(noteDetailVC, animated: true)
        }
    }
}

//MARK: - NoteDetailControllerDelegate
extension FolderDetailController: NoteDetailControllerDelegate {
    func doneEditing(_ note: String) {
        if isNewNote {
            guard note != "" else { return }
            notesManager.createNew(note: note, folderID: currentFolderID)
        } else {
            notesManager.update(note: note, noteID: selectedNoteID, folderID: currentFolderID)
        }
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
