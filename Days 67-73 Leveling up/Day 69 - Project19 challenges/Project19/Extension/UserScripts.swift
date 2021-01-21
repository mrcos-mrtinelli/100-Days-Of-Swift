//
//  UserScripts.swift
//  Extension
//
//  Created by Marcos Martinelli on 1/19/21.
//

import Foundation

class UserScripts: Codable {
    var url: URL
    var name: String
    var script: String
    
    init(url: URL, name: String, script: String) {
        self.url = url
        self.name = name
        self.script = script
    }
}
