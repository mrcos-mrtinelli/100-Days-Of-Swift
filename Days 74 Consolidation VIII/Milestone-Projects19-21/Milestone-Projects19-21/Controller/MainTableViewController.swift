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
        
        let spacer = UIBarButtonItem(systemItem: .flexibleSpace)
        let newFolderIcon = UIImage(systemName: "folder.badge.plus")
        let newFolder = UIBarButtonItem(image: newFolderIcon, style: .plain, target: self, action: #selector(addFolderTapped))
        let newNoteIcon = UIImage(systemName: "square.and.pencil")
        let newNote = UIBarButtonItem(image: newNoteIcon, style: .plain, target: self, action: #selector(addNoteTapped))
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.isToolbarHidden = false
        toolbarItems = [newFolder, spacer, newNote]
        title = "Notes"
        
        
        notesManager.delegate = self
        notesManager.load()
    }//MARK: tableView
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
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let folderDetailVC = storyboard?.instantiateViewController(identifier: "FolderDetail") as? FolderDetailTableViewController {
            folderDetailVC.folder = allNotes[indexPath.row]
            navigationController?.pushViewController(folderDetailVC, animated: true)
        }
    }
    
    //MARK: toolBar
    @objc func addFolderTapped() {
        let ac = UIAlertController(title: "New Folder", message: "Enter a name for this folder.", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let submit = UIAlertAction(title: "Save", style: .default) { [weak self, weak ac] _ in
            guard let name = ac!.textFields![0].text else { return }
            
            // update this to disable/enable Save button based on name
            if name != "" {
                guard let notes = self?.allNotes else { return }
                self?.notesManager.addNewFolder(name, to: notes)
            } else {
                let warning = UIAlertController(title: "Error", message: "You must enter a name for your folder.", preferredStyle: .alert)
                warning.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self?.present(warning, animated: true, completion: nil)
            }
        }
        
        ac.addTextField { (textField) in
            // https://stackoverflow.com/questions/31922349/how-to-add-textfield-to-uialertcontroller-in-swift
            textField.placeholder = "Name"
        }
        ac.addAction(cancel)
        ac.addAction(submit)
        
        present(ac, animated: true)
        
    }
    @objc func addNoteTapped() {
        
    }
}


//MARK: NotesManagerDelegate
extension MainTableViewController: NotesManagerDelegate {
    func didLoadNotes(_ notesManager: NotesManager, notes: [Folder]) {
        allNotes = notes
        tableView.reloadData()
    }
    func didAddNewFolder(newFolder: Folder, index: Int) {
        allNotes.insert(newFolder, at: index)
        let indexPath = IndexPath(row: index, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
}

