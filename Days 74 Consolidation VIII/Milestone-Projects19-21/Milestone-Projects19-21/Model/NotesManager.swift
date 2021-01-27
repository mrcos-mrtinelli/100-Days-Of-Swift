//
//  StorageManager.swift
//  Milestone-Projects19-21
//
//  Created by Marcos Martinelli on 1/24/21.
//

import Foundation

protocol NotesManagerDelegate {
    func didLoadNotes(_ notesManager: NotesManager, folders: [Folder])
    func didAddNewFolder(newFolder: Folder, index: Int)
}

struct NotesManager {
    let key = "notes"
    
    var delegate: NotesManagerDelegate?
    var allFolders = [Folder]()
    
    
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
    mutating func load() {
        let defaults = UserDefaults.standard
//        var folders = [Folder]()
        
        if let savedData = defaults.object(forKey: key) as? Data {
            print("found saved data")
            if let decodedData = decodeJSON(savedData) {
                allFolders = decodedData
            }
        } else {
            let firstNote = Note(body: """
                    This is a notes with multiple lines.
                    line two is on a different line.
                    line three is on yet another different line.
                    """)
            allFolders = [Folder(id: UUID(), name: "All Notes", notes: [firstNote])]
        }
        
        delegate?.didLoadNotes(self, folders: allFolders)
    }
    func save(_ allNotes: [Folder]) {
        print("save(newFolder)")
    }
    
    func addNewNote(folder: String) {
        
    }
    
    func addNewFolder(_ name: String, to folders: [Folder]) {
        let newFolder = Folder(id: UUID(), name: name, notes: [Note]())
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
