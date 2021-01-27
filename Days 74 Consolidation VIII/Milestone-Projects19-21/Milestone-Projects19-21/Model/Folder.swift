//
//  Folders.swift
//  Milestone-Projects19-21
//
//  Created by Marcos Martinelli on 1/24/21.
//

import Foundation


struct Folder: Codable {
    var id: UUID
    var name: String
    var notes: [Note]
}
