//
//  StorageManager.swift
//  Milestone-Projects19-21
//
//  Created by Marcos Martinelli on 1/24/21.
//

import Foundation

protocol NotesManagerDelegate {
    func didLoad(_ notesManager: NotesManager, folders: [Folder])
    func didAddNewFolder(newFolder: Folder, index: Int)
}

struct NotesManager {
    let key = "notes"
    
    var delegate: NotesManagerDelegate?
    
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
    func getSavedData() -> [Folder] {
        let defaults = UserDefaults.standard
    
        if let savedData = defaults.object(forKey: key) as? Data {
            print("found saved data")
            if let decodedData = decodeJSON(savedData) {
                return decodedData
            }
        }
        
        let firstNote = Note(body: """
                    This is a notes with multiple lines.
                    line two is on a different line.
                    line three is on yet another different line.
                    """)
        return [Folder(id: UUID(), name: "All Notes", notes: [firstNote])]
    }
    func load() {
        let folders = getSavedData()
        
        delegate?.didLoad(self, folders: folders)
    }
    func save(_ allNotes: [Folder]) {
        let encoder = JSONEncoder()
        
        if let savedData = try? encoder.encode(allNotes) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: key)
            print("saved!")
        } else {
            print("error saving")
        }
        
    }
    
    func addNewNote(folder: String) {
        
    }
    
    func addNewFolder(_ name: String, to folders: [Folder]) {
        let newFolder = Folder(id: UUID(), name: name, notes: [Note]())
        var allFolders = getSavedData()
        allFolders.append(newFolder)
        
        let sortedFolders = sortFolders(folders: allFolders)
        let index = sortedFolders.firstIndex { (folder) in
            return folder.id == newFolder.id
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
