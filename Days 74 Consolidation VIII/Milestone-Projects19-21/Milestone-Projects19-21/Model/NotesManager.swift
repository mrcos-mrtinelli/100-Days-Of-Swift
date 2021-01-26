//
//  StorageManager.swift
//  Milestone-Projects19-21
//
//  Created by Marcos Martinelli on 1/24/21.
//

import Foundation

protocol NotesManagerDelegate {
    func didLoadNotes(_ notesManager: NotesManager, notes: [Folder])
    func updateUI()
    func didAddNewFolder(newFolder: Folder, index: Int)
}

struct NotesManager {
    var delegate: NotesManagerDelegate?
    let key = "notes"
    
    func decodeJSON(_ data: Data) -> [Folder]? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode([Folder].self, from: data)
            return decodedData
        } catch {
            print("Unable to decoded data.")
        }
        
        return [Folder]()
    }
    func load() {
        print("Storage.load")
        let defaults = UserDefaults.standard
        var notes = [Folder]()
        
        if let savedData = defaults.object(forKey: key) as? Data {
            print("found saved data")
            if let decodedData = decodeJSON(savedData) {
                notes = decodedData
            }
        } else {
            print("no saved data found")
            notes = [Folder(name: "All Notes", notes: [Note]())]
        }
        
        delegate?.didLoadNotes(self, notes: notes)
    }
    func save(_ allNotes: [Folder]) {
        print("save(newFolder)")
    }
    
    func addNewFolder(_ name: String, to folders: [Folder]) {
        let newFolder = Folder(name: name, notes: [Note]())
        var allFolders = folders
        allFolders.append(newFolder)
        
        let sortedFolders = sortFolders(folders: allFolders)
        let index = sortedFolders.firstIndex { (folder) in
            return folder.name == newFolder.name
        }
        
        save(sortedFolders)
        
        delegate?.didAddNewFolder(newFolder: newFolder, index: index!)
    }
    func sortFolders(folders: [Folder]) -> [Folder] {
        var mutableFolders = folders
        let allNotesFolder = mutableFolders.removeFirst()
        var sortedFolders = mutableFolders.sorted { (a, b) in
            return a.name < b.name
        }
        sortedFolders.insert(allNotesFolder, at: 0)
        
        return sortedFolders
    }
}
