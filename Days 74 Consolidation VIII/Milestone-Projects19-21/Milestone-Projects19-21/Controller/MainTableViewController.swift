//
//  ViewController.swift
//  Milestone-Projects19-21
//
//  Created by Marcos Martinelli on 1/24/21.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    var notesManager = NotesManager()
    var allFolders = [Folder]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let spacer = UIBarButtonItem(systemItem: .flexibleSpace)
        let newFolderIcon = UIImage(systemName: "folder.badge.plus")
        let newFolder = UIBarButtonItem(image: newFolderIcon, style: .plain, target: self, action: #selector(addFolderTapped))
        let newNoteIcon = UIImage(systemName: "square.and.pencil")
        let newNote = UIBarButtonItem(image: newNoteIcon, style: .plain, target: self, action: #selector(addNoteTapped))
        
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
        if let folderDetailVC = storyboard?.instantiateViewController(identifier: "FolderDetail") as? FolderDetailTableViewController {
            folderDetailVC.folder = allFolders[indexPath.row]
            navigationController?.pushViewController(folderDetailVC, animated: true)
        }
    }
    
    //MARK: - toolBar
    @objc func addFolderTapped() {
        let ac = UIAlertController(title: "New Folder", message: "Enter a name for this folder.", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let submit = UIAlertAction(title: "Save", style: .default) { [weak self, weak ac] _ in
            guard let name = ac!.textFields![0].text else { return }
            
            self?.notesManager.addNew(folder: name)
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
    @objc func addNoteTapped() {
        if let noteDetail = storyboard?.instantiateViewController(identifier: "NoteDetail") as? NoteDetailViewController {
            noteDetail.delegate = self
            noteDetail.folderID = allFolders[0].id // All Notes is always 0 index
            noteDetail.body = ""
            
            navigationController?.pushViewController(noteDetail, animated: true)
        }
    }
}

//MARK: - NotesManagerDelegate
extension MainTableViewController: NotesManagerDelegate {
    func didLoad(_ notesManager: NotesManager, folders: [Folder]) {
        allFolders = folders
        tableView.reloadData()
    }
    func didAddNew(folder: Folder, at: Int) {
        allFolders.insert(folder, at: at)
        let indexPath = IndexPath(row: at, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    func didSave() {
        notesManager.loadAllFolders()
    }
}
extension MainTableViewController: NoteDetailViewControllerDelegate {
    func addNewNote(note: String, folderID: UUID) {
        notesManager.addNew(note: note, folderID: folderID)
    }
}
