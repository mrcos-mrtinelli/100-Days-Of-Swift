//
//  Pictures.swift
//  Day50MilestoneProject
//
//  Created by Marcos Martinelli on 12/31/20.
//

import UIKit

class Pictures: NSObject, Codable {
    var picture: String
    var caption: String
    
    init(picture: String, caption: String) {
        self.picture = picture
        self.caption = caption
    }
}
