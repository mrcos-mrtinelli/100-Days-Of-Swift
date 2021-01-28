//
//  StorageManager.swift
//  Milestone-Projects19-21
//
//  Created by Marcos Martinelli on 1/24/21.
//

import Foundation

protocol NotesManagerDelegate {
    func didLoad(_ notesManager: NotesManager, folders: [Folder])
    func didAddNew(folder: Folder, at index: Int)
    func didSave(_ folders: [Folder])
    func didLoadFolderContent(folder: Folder)
}
extension NotesManagerDelegate {
    func didLoad(_ notesManager: NotesManager, folders: [Folder]) {}
    func didAddNew(folder: Folder, at index: Int) {}
    func didSave() {}
    func didLoadFolderContent(folder: Folder) {}
}

struct NotesManager {
    let key = "notes"
    
    var delegate: NotesManagerDelegate?
    
    //MARK: - JSON Utilities
    func encodeJSON(folders: [Folder]) -> Data? {
        let jsonEncoder = JSONEncoder()
        
        do {
            let encodedData = try jsonEncoder.encode(folders)
            return encodedData
        } catch {
            print(error)
            return nil
        }
    }
    func decodeJSON(_ data: Data) -> [Folder]? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode([Folder].self, from: data)
            return decodedData
        } catch {
            print("Unable to decoded data.")
        }
        
        return nil
    }
    //MARK: - Save and Load Utilities
    func save(folders: [Folder]) {
        
        guard let encodedNotes = encodeJSON(folders: folders) else {
            print("Error saving")
            return
        }

        let defaults = UserDefaults.standard
        defaults.set(encodedNotes, forKey: key)
        print("saved!")
        
        delegate?.didSave(folders)
    }
    func getSavedData() -> [Folder] {
        let defaults = UserDefaults.standard
    
        if let savedData = defaults.object(forKey: key) as? Data {
            print("found saved data")
            if let decodedData = decodeJSON(savedData) {
                return decodedData
            }
        }
        
        let firstNote = Note(id: UUID().uuidString, body: """
                    This is a notes with multiple lines.
                    line two is on a different line.
                    line three is on yet another different line.
                    """)
        return [Folder(id: "allNotes", name: "All Notes", notes: [firstNote])]
    }
    func loadAllFolders() {
        let folders = getSavedData()
        
        delegate?.didLoad(self, folders: folders)
    }
    func loadFolderContents(folderID: String) {
        let allFolders = getSavedData()
        let index = getFolderIndex(for: folderID, in: allFolders)
        
        delegate?.didLoadFolderContent(folder: allFolders[index])
    }
    //MARK: Folder and Note Utilities
    func addNew(note: String, folderID: String) {
        var savedData = getSavedData()
        
        let index = getFolderIndex(for: folderID, in: savedData)
        let newNote = Note(id: UUID().uuidString, body: note)
        
        savedData[index].notes.append(newNote)
        
        save(folders: savedData)
    }
    
    func addNew(folder name: String) {
        let newFolder = Folder(id: UUID().uuidString, name: name, notes: [Note]())
        
        var allFolders = getSavedData()
        allFolders.append(newFolder)
        
        let sortedFolders = sortFolders(folders: allFolders)
        let index = sortedFolders.firstIndex { (folder) in
            return folder.id == newFolder.id
        }
        
        save(folders: sortedFolders)
        
        delegate?.didAddNew(folder: newFolder, at: index!)
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
    func getFolderIndex(for folderID: String, in folders: [Folder]) -> Int {
        if let folderIndex = folders.firstIndex(where: {(folder) in folder.id == folderID}) {
            return folderIndex
        }
        return 0
    }
}

