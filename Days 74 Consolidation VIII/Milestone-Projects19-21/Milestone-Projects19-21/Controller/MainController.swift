//
//  ViewController.swift
//  Milestone-Projects19-21
//
//  Created by Marcos Martinelli on 1/24/21.
//

import UIKit

class MainController: UITableViewController {
    
    var notesManager = NotesManager()
    var allFolders = [Folder]()
    var currentFolderID = "allNotes"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let spacer = UIBarButtonItem(systemItem: .flexibleSpace)
        let newFolderIcon = UIImage(systemName: "folder.badge.plus")
        let newFolder = UIBarButtonItem(image: newFolderIcon, style: .plain, target: self, action: #selector(createNewFolder))
        let newNoteIcon = UIImage(systemName: "square.and.pencil")
        let newNote = UIBarButtonItem(image: newNoteIcon, style: .plain, target: self, action: #selector(createNewNote))
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.isToolbarHidden = false
        toolbarItems = [newFolder, spacer, newNote]
        title = "Folders"
        
        notesManager.delegate = self
        notesManager.loadAllFolders()
    }
    //MARK: - tableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allFolders.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FolderCell", for: indexPath)
        
        if let folderCell = cell as? FolderCell {
            folderCell.folderName.text = allFolders[indexPath.row].name
            folderCell.notesCount.text = "\(allFolders[indexPath.row].notes.count)"
            return folderCell
        }
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let folderDetailVC = storyboard?.instantiateViewController(identifier: "FolderDetail") as? FolderDetailController {
            folderDetailVC.folder = allFolders[indexPath.row]
            folderDetailVC.currentFolderID = allFolders[indexPath.row].id
            navigationController?.pushViewController(folderDetailVC, animated: true)
        }
    }
    
    //MARK: - toolBar
    @objc func createNewFolder() {
        let ac = UIAlertController(title: "New Folder", message: "Enter a name for this folder.", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let submit = UIAlertAction(title: "Save", style: .default) { [weak self, weak ac] _ in
            guard let name = ac!.textFields![0].text else { return }
            
            self?.notesManager.createNew(folder: name)
        }
        
        ac.addTextField { (textField) in
            // https://stackoverflow.com/questions/31922349/how-to-add-textfield-to-uialertcontroller-in-swift
            textField.placeholder = "Name"
            
            // https://gist.github.com/TheCodedSelf/c4f3984dd9fcc015b3ab2f9f60f8ad51
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: .main) { _ in
                if textField.hasText {
                    submit.isEnabled = true
                } else {
                    submit.isEnabled = false
                }
            }
        }
        ac.addAction(cancel)
        submit.isEnabled = false
        ac.addAction(submit)
        
        present(ac, animated: true)
        
    }
    @objc func createNewNote() {
        if let noteVC = storyboard?.instantiateViewController(identifier: "NoteDetail") as? NoteDetailController {
            noteVC.delegate = self
            navigationController?.pushViewController(noteVC, animated: true)
        }

    }
}

//MARK: - NotesManagerDelegate
extension MainController: NotesManagerDelegate {
    func didLoad(_ notesManager: NotesManager, folders: [Folder]) {
        allFolders = folders
        tableView.reloadData()
    }
    func didSave(folder: Folder, at: Int) {
        allFolders.insert(folder, at: at)
        let indexPath = IndexPath(row: at, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    func didSave(note: Note, to folders: [Folder]) {
        allFolders = folders
        tableView.reloadData()
    }
}

//MARK: - NoteDetailControllerDelegate
extension MainController: NoteDetailControllerDelegate {
    func didCreateNote(_ note: String?) {
        guard let body = note, note != "" else { return }
        notesManager.createNew(note: body, noteID: nil, folderID: currentFolderID)
    }
}

